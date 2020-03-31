require "rails_helper"

RSpec.describe "Post requests", type: :request do
  let(:json) { JSON.parse(response.body) }

  describe "GET calls" do
    before do
      @fan      = create :fan
      @athlete  = create :athlete
      @athlete2 = create :athlete
      create_list(:post, 5, :completed, :video, :with_reactions, :with_comments, :with_tags, athlete: @athlete)
      create_list(:post, 2, :pending, :video, athlete: @athlete)
      create_list(:post, 5, :completed, :video, :with_reactions, :with_comments, :with_tags, athlete: @athlete2)
    end

    after do
      Fan.destroy_all
      Athlete.destroy_all
      Post.destroy_all
    end

    describe "#index" do
      context "as a fan" do
        before do
          @fan.follow @athlete
          get "/api/v1/posts",
            headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
        end

        it "returns the proper status code" do
          expect(response.status).to eq 200
        end

        it "returns the proper schema" do
          expect(response).to match_response_schema("posts")
        end

        it "returns only completed posts that belong to athletes the user follows" do
          expect(json["posts"].count).to eq(5)
        end
      end

      context "as an athlete" do
        before do
          @athlete2.follow @athlete
          get "/api/v1/posts",
          headers: { "X-Athlete-Auth-Token" => @athlete2.api_key, "Content-Type" => "application/json" }
        end

        it "returns the proper status code" do
          expect(response.status).to eq 200
        end

        it "returns the proper schema" do
          expect(response).to match_response_schema("posts")
        end

        it "returns only completed posts that belong to the current athlete AND athletes they follow" do
          expect(json["posts"].count).to eq(10)
        end
      end
    end

    describe "#by_athlete" do
      before do
        get "/api/v1/athletes/#{@athlete.id}/posts",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "returns the proper response code" do
        expect(response.status).to eq 200
      end

      it "returns the proper schema" do
        expect(response).to match_response_schema("posts")
      end

      it "returns no posts from any other athlete" do
        expect(json["posts"].select{ |p| p["athlete"]["id"] == @athlete.id }.count).to eq(json["posts"].count)
      end
    end

    describe "#show" do
      before do
        get "/api/v1/posts/#{@athlete.posts.last.id}",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "returns the proper response code" do
        expect(response.status).to eq 200
      end

      it "returns the proper schema" do
        expect(response).to match_response_schema("post")
      end
    end
  end

  describe "#create" do
    before do
      @athlete       = create :athlete
      @athlete2      = create :athlete
      @fan           = create :fan
      @video         = create :video
      @post_params   = { content_type: "video",
                         url: "http://www.url.com",
                         thumbnail_url: "http://www.thumb_url.com"
                       }
      @post_tag_params   = @post_params.merge(tags: ["#awesome", "#gnarly", @athlete2.id.to_s])
      @post_image_params = @post_params.merge(image_guid: "ABCD1234")
      @post_video_params = @post_params.merge(video_guid: @video.guid, panda_video_id: "abcd123")
    end

    after do
      Athlete.destroy_all
      Fan.destroy_all
      Post.destroy_all
    end

    context "creating" do
      before do
        post "/api/v1/posts",
          params: { post: @post_params }.to_json,
          headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json" }
      end

      it "does not fire the image downloader without an image" do
        expect(ImageDownloadJob).not_to receive(:perform_async)
      end

      it "responds with the proper code" do
        expect(response.status).to eq 201
      end

      it "adds a post to an athlete" do
        expect(@athlete.posts.count).to eq(1)
      end

      it "matches the correct response schema" do
        expect(response).to match_response_schema("post")
      end
    end

    context "with tags" do
      before do
        post "/api/v1/posts",
          params: { post: @post_tag_params }.to_json,
          headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json" }
      end

      it "has hashtags" do
        expect(json["hashtags"].include?("#gnarly")).to be true
      end

      it "has athlete mentions" do
        expect(json["mentions"].count).to eq(1)
      end

      it "matches the correct response schema" do
        expect(response).to match_response_schema("post")
      end

    end

    context "with an image" do
      before do
        expect(ImageDownloadJob).to receive(:perform_async)
        post "/api/v1/posts",
          params: { post: @post_image_params }.to_json,
          headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json" }
      end

      it "matches the correct response schema" do
        expect(response).to match_response_schema("post")
      end
    end

    context "with a video" do
      before do
        expect(VideoPostAssociator).to receive(:call)
        post "/api/v1/posts",
          params: { post: @post_video_params }.to_json,
          headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json" }
      end

      it "matches the correct response schema" do
        expect(response).to match_response_schema("post")
      end
    end

    context "as a reaction" do
      before do
        @parent_post    = create :post, athlete: @athlete
        reaction_params = @post_params.merge({ parent_id: @parent_post.id })
        expect(@athlete.posts.first.reactions.count).to eq(0)
        post "/api/v1/posts",
          params: reaction_params.to_json,
          headers: { "X-Athlete-Auth-Token" => @athlete2.api_key, "Content-Type" => "application/json" }
      end

      it "returns the proper response code" do
        expect(response.status).to eq 201
      end

      it "attaches the reaction to the proper post" do
        expect(@parent_post.reactions.count).to eq 1
      end
    end

    context "as a fan" do
      before do
        post "/api/v1/posts",
          params: { post: @post_params }.to_json,
          headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "brings you bad juju to try and create a post as a fan" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "#update" do
    before do
      @athlete       = create :athlete
      @athlete2      = create :athlete
      @post          = create :post, athlete: @athlete, content_type: "image"
      @post_update   = { content_type: "video" }
    end

    describe "updating a post" do

      it "allows an athlete to update their post" do
        patch "/api/v1/posts/#{@post.id}",
          params: { post: @post_update }.to_json,
          headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json" }
        expect(response.status).to eq 200
      end

      it "does not allow another athlete to update someone else's post" do
        patch "/api/v1/posts/#{@post.id}",
          params: { post: @post_update }.to_json,
          headers: { "X-Athlete-Auth-Token" => @athlete2.api_key, "Content-Type" => "application/json" }
        expect(response.status).to eq 401
      end
    end
  end

  describe "#shared_video" do
    before(:example) do
      @athlete  = create :athlete
      @athlete2 = create :athlete
      @post     = create :post, athlete: @athlete, share_count: 1
    end

    it "updates the posts shared count by sharing" do
      post "/api/v1/posts/#{@post.id}/shared_video",
      headers: { "X-Athlete-Auth-Token" => @athlete2.api_key, "Content-Type" => "application/json" }
      @post.reload
      expect(@post.share_count).to eq(1)
    end
  end

  describe "#flag" do
    before do
      @athlete         = create :athlete
      @athlete2        = create :athlete
      @fan             = create :fan
      @post            = create :post, athlete: @athlete
    end

    context "as a fan" do
      it "flags content as objectionable" do
        expect(FlagContentJob).to receive(:perform_async).with(@post.id, @fan.id, @fan.class.to_s).and_return(true)
        post "/api/v1/posts/#{@post.id}/flag",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
        expect(response.status).to eq 200
      end
    end

    context "as an athlete" do
      it "flags content as objectionable" do
        expect(FlagContentJob).to receive(:perform_async).with(@post.id, @athlete2.id, @athlete2.class.to_s).and_return(true)
        post "/api/v1/posts/#{@post.id}/flag",
        headers: { "X-Athlete-Auth-Token" => @athlete2.api_key, "Content-Type" => "application/json" }
        expect(response.status).to eq 200
      end
    end
  end

  describe "#destroy" do
    before(:example) do
      @athlete         = create :athlete
      @athlete2        = create :athlete
      @post            = create :post, athlete: @athlete, status: "complete"
    end

    context "a post as the post owner" do
      before do
        delete "/api/v1/posts/#{@post.id}",
        headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json" }
      end

      it "returns the proper response code" do
        expect(response.status).to eq 204
      end

      it "sets the post's status to archived" do
        @post.reload
        expect(@post.status).to eq("archived")
      end
    end

    context "a post as someone who doesn't own the post" do
      before do
        delete "/api/v1/posts/#{@post.id}",
        headers: { "X-Athlete-Auth-Token" => @athlete2.api_key, "Content-Type" => "application/json" }
      end

      it "returns unauthorized" do
        expect(response.status).to eq 401
      end

      it "doesn't affect the post" do
        @post.reload
        expect(@post.status).to eq("complete")
      end
    end
  end

  describe "#like" do
    before do
      @athlete         = create :athlete
      @athlete2        = create :athlete
      @fan             = create :fan
      @post            = create :post, athlete: @athlete, status: "complete"
    end

    context "as a fan" do
      before do
        post "/api/v1/posts/#{@post.id}/like",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "returns the proper response code" do
        expect(response.status).to eq 200
      end

      it "creates a like for the fan" do
        expect(@fan.voted_up_on?(@post)).to be true
      end
    end

    context "as an athlete" do
      before do
        post "/api/v1/posts/#{@post.id}/like",
        headers: { "X-Athlete-Auth-Token" => @athlete2.api_key, "Content-Type" => "application/json" }
      end

      it "returns the proper response code" do
        expect(response.status).to eq 200
      end

      it "creates a like for the fan" do
        expect(@athlete2.voted_up_on?(@post)).to be true
      end
    end
  end

  describe "#unlike" do
    before do
      @athlete         = create :athlete
      @athlete2        = create :athlete
      @fan             = create :fan
      @post            = create :post, athlete: @athlete, status: "complete"
      @post.liked_by @fan
      @post.liked_by @athlete2
    end

    context "as a fan" do
      before do
        post "/api/v1/posts/#{@post.id}/unlike",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "returns the proper code" do
        expect(response.status).to eq 200
      end

      it "removes a like from a fan" do
        expect(@fan.voted_up_on?(@post)).to be false
      end
    end
    context "as an athlete" do
      before do
        post "/api/v1/posts/#{@post.id}/unlike",
        headers: { "X-Athlete-Auth-Token" => @athlete2.api_key, "Content-Type" => "application/json" }
      end

      it "returns the proper code" do
        expect(response.status).to eq 200
      end

      it "removes a like from a fan" do
        expect(@athlete2.voted_up_on?(@post)).to be false
      end
    end
  end

  describe "#dislike" do
    before do
      @athlete         = create :athlete
      @athlete2        = create :athlete
      @fan             = create :fan
      @post            = create :post, athlete: @athlete, status: "complete"
    end

    context "as a fan" do
      before do
        post "/api/v1/posts/#{@post.id}/dislike",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "returns the correct status code" do
        expect(response.status).to eq 200
      end

      it "records the fan dislike" do
        expect(@fan.voted_down_on?(@post)).to be true
      end
    end

    context "as an athlete" do
      before do
        post "/api/v1/posts/#{@post.id}/dislike",
        headers: { "X-Athlete-Auth-Token" => @athlete2.api_key, "Content-Type" => "application/json" }
      end

      it "returns the correct status code" do
        expect(response.status).to eq 200
      end

      it "records the fan dislike" do
        expect(@athlete2.voted_down_on?(@post)).to be true
      end
    end
  end

  describe "#undislike" do
    before do
      @athlete         = create :athlete
      @athlete2        = create :athlete
      @fan             = create :fan
      @post            = create :post, athlete: @athlete, status: "complete"
      @post.disliked_by @fan
      @post.disliked_by @athlete2
    end

    context "as a fan" do
      before do
        post "/api/v1/posts/#{@post.id}/undislike",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "allows a fan to undislike a post" do
        expect(response.status).to eq 200
      end

      it "records the undislike" do
        expect(@fan.voted_down_on?(@post)).to be false
      end
    end

    context "as an athlete" do
      before do
        post "/api/v1/posts/#{@post.id}/undislike",
        headers: { "X-Athlete-Auth-Token" => @athlete2.api_key, "Content-Type" => "application/json" }
      end

      it "allows a fan to undislike a post" do
        expect(response.status).to eq 200
      end

      it "records the undislike" do
        expect(@athlete.voted_down_on?(@post)).to be false
      end
    end
  end
end
