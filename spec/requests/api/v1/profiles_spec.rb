require "rails_helper"

RSpec.describe "Profiles Requests", type: :request do

  let(:json) { JSON.parse(response.body) }

  before(:context) do
    Fan.destroy_all
    Athlete.destroy_all
  end

  after(:context) do
    Fan.destroy_all
    Athlete.destroy_all
  end

  describe "#me" do
    before do
      stub_request(:get, ENV["AWS_VERIFICATION_URL"])
        .with(headers: { "Accept" => "*/*",
                         "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
                         "User-Agent" => "Ruby" })
        .to_return(status: 200, body: "", headers: {})
    end

    context "as a fan" do
      it "should respond with my information" do
        fan = create :fan
        get '/api/v1/me',
          headers: { "X-Fan-Auth-Token" => fan.api_key, "Content-Type" => "application/json" }
        # test for the 200 status-code and attrs
        expect(response).to be_success
        expect(response).to match_response_schema("me")
      end
    end

    context "as an athlete" do
      it "should respond with my information" do
        athlete = create :athlete
        get '/api/v1/me',
          headers: { "X-Athlete-Auth-Token" => athlete.api_key, "Content-Type" => "application/json" }
        # test for the 200 status-code and attrs
        expect(response).to be_success
        expect(response).to match_response_schema("me")
      end
    end

  end


  describe "When the current user updates their password" do
    before(:example) do
      @fan = create :fan
    end

    it "returns a 200 on updating the password" do
      patch "/api/v1/update_me.json",
        params: { password: "asdf", password_confirmation: "asdf" }.to_json,
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      expect(response.status).to eq 200
    end

    it "will not allow the user to hit the api again using the old api key" do
      @fan.reload
      get "/api/v1/me.json",
        headers: { "X-Fan-Auth-Token" => @old_key, "Content-Type" => "application/json" }
      expect(response.status).to eq 401
    end
  end

  describe "#update with no image url" do
    before(:example) do
      @fan_params = { first_name: "Joe", last_name: "Bagels" }
      stub_request(:get, ENV["AWS_VERIFICATION_URL"])
        .with(headers: { "Accept" => "*/*",
                         "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
                         "User-Agent" => "Ruby" })
        .to_return(status: 200, body: "", headers: {})
    end

    it "should respond with a 200 OK" do
      fan = create :fan
      patch '/api/v1/update_me',
        params: @fan_params.to_json,
        headers: { "X-Fan-Auth-Token" => fan.api_key, "Content-Type" => "application/json" }
      expect(response).to be_success
    end

    it "should update the fan information" do
      fan = create :fan
      patch '/api/v1/update_me',
        params: @fan_params.to_json,
        headers: { "X-Fan-Auth-Token" => fan.api_key, "Content-Type" => "application/json" }
      fan.reload
      expect(fan.first_name).to eq("Joe")
      expect(fan.last_name).to eq("Bagels")
    end
  end

  describe "#update with an image_download_url" do
    before(:example) do
      @fan_params = { first_name: "Joe", last_name: "Bagels", image_guid: "ABCD1234" }
      stub_request(:get, "http://image.com/")
        .with(headers: { "Accept" => "*/*",
                         "Accept-Encoding" => "gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
                         "User-Agent" => "Ruby" })
        .to_return(status: 200, body: "", headers: {})
    end

    it "should create a downloader job" do
      fan = create :fan
      downloader = double("Downloader")
      allow(AvatarDownloader).to receive(:new).with(fan.avatar.id, "ABCD1234") { downloader }
      allow(AvatarDownloader).to receive(:call).with(fan.avatar.id, "ABCD1234") { true }
      expect(AvatarDownloadJob).to receive(:perform_async).with(fan.avatar.id, "ABCD1234")
      patch '/api/v1/update_me',
        params: @fan_params.to_json,
        headers: { "X-Fan-Auth-Token" => fan.api_key, "Content-Type" => "application/json" }
    end
  end

  describe "#update with underscored params" do
    it "should allow a password update with underscored password_confirmation" do
      fan = create :fan
      patch '/api/v1/update_me',
        params: { password: "asdf", password_confirmation: "asdf" }.to_json,
        headers: { "X-Fan-Auth-Token" => fan.api_key, "Content-Type" => "application/json" }
      expect(response.status).to eq 200
    end
  end

  describe "#update with camelcased params" do
    it "should allow a password update with camelCased passwordConfirmation" do
      fan = create :fan
      patch '/api/v1/update_me',
        params: { password: "asdf", passwordConfirmation: "asdf" }.to_json,
        headers: { "X-Fan-Auth-Token" => fan.api_key, "Content-Type" => "application/json" }
      expect(response.status).to eq 200
    end
  end

  describe "failed #update with no pass confirmation" do
    it "should fail a password update with no confirmation" do
      fan = create :fan
      patch '/api/v1/update_me',
        params: { password: "asdf" }.to_json,
        headers: { "X-Fan-Auth-Token" => fan.api_key, "Content-Type" => "application/json" }
      expect(response.status).to eq 400
      expect(json["errors"].first["title"]).to eq "does not match the confirmation password."
    end
  end

  describe "failed #update with non matching confirmation" do
    it "should fail a password update with non-matching confirmation" do
      fan = create :fan
      patch '/api/v1/update_me',
        params: { password: "asdf", password_confirmation: "asdfg" }.to_json,
        headers: { "X-Fan-Auth-Token" => fan.api_key, "Content-Type" => "application/json" }
      expect(response.status).to eq 400
      expect(json["errors"].first["title"]).to eq "does not match the confirmation password."
    end
  end

  describe "When the current user updates their info without updating their password" do
    before(:example) do
      @fan = create :fan
    end

    it "will not allow the user to hit the api again using the old api key" do
      patch "/api/v1/update_me.json",
        params: { first_name: "Billy Joe Jack",
          last_name: "Johnsonson",
          email: "billy@joejackjohnson.com"
        }.to_json,
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      expect(response.status).to eq 200

      get "/api/v1/me.json",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      expect(response.status).to eq 200
      expect(json["me"]["first_name"]).to eq "Billy Joe Jack"
    end
  end

  describe "#followers" do
    before(:example) do
      @fan = create :fan
      @followers = create_list(:athlete, 26)
      @athlete = create :athlete
      @followers.map{ |f| f.follow(@athlete)}
      @athlete_params = { athlete_id: @athlete.id }

      get "/api/v1/athletes/#{@athlete.id}/followers",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
    end

    it "matches our response schema for followers" do
      expect(response).to match_response_schema("followers")
    end

    it "creates json next links correctly for followers" do
      expect(json["links"]["next"]).to eq("http://www.example.com/api/v1/athletes/#{@athlete.id}/followers?page=2")
      expect(json["links"]["previous"]).to eq nil
    end

    it "is paginated to deliver 25 followers per call" do
      expect(json["athletes"].count).to eq 25
    end
  end

  describe "#following" do
    before(:example) do
      @fan = create :fan
      @followers = create_list(:athlete, 26)
      @athlete = create :athlete
      @followers.map{ |f| @athlete.follow(f)}
      @athlete_params = { athlete_id: @athlete.id }

      get "/api/v1/athletes/#{@athlete.id}/following",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
    end

    it "matches our response schema for following" do
      expect(response).to match_response_schema("followers")
    end

    it "creates json next links correctly for following" do
      expect(json["links"]["next"]).to eq("http://www.example.com/api/v1/athletes/#{@athlete.id}/following?page=2")
      expect(json["links"]["previous"]).to eq nil
    end

    it "is paginated to deliver 25 following athletes per call" do
      expect(json["athletes"].count).to eq 25
    end
  end

  describe "#reactions" do
    before(:example) do
      @fan     = create :fan
      @athlete = create :athlete
      @post    = create :post, athlete: @athlete, content_type: "video", status: "complete"
    end

    it "doesn't return a list of reactions if the current user is a fan" do
      get "/api/v1/athletes/#{@athlete.id}/reactions",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      expect(response.status).to eq(401)
    end

    it "matches response schema for reactions" do
      get "/api/v1/athletes/#{@athlete.id}/reactions",
        headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json" }
      expect(response).to match_response_schema("posts")
    end
  end

  describe "#answers" do
    before(:example) do
      @athlete  = create :athlete
      @question = create :question
      @post     = create :post, athlete: @athlete, content_type: "video", status: "complete",
        parent_id: @question.id, parent_type: "Question"
      get "/api/v1/athletes/#{@athlete.id}/answers",
        headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json" }
    end

    it "matches our response schema for answers" do
      expect(response).to match_response_schema("answers")
    end
  end

  describe "#liked_posts" do
    before(:example) do
      @mj     = create :athlete
      @kobe   = create :athlete
      @lebron = create :athlete
      @fan    = create :fan
      @fan.follow @mj
      @post = create :post, content_type: "video", athlete_id: @mj.id, status: :complete
      @post.liked_by @kobe
      @post.liked_by @fan
      @comment = create :comment, athlete_id: @lebron.id, commentable_id: @post.id, commentable_type: "Post",
        text: "The King wants a ring."
      @reaction = create :post, content_type: "video", athlete_id: @kobe.id, status: :complete,
        parent_id: @post.id, parent_type: "Post"
      @post.athletes_tagged_list = [@lebron.id.to_s, @kobe.id.to_s]
      @post.save!
    end

    it "matches the proper schema on liked posts" do
      get "/api/v1/fans/#{@fan.id}/liked_posts",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      expect(response).to match_response_schema("posts")
    end
  end

  describe "#liked_questions" do
    before(:example) do
      @mj     = create :athlete
      @kobe   = create :athlete
      @lebron = create :athlete
      @fan    = create :fan
      @fan.follow @mj
      @question = create :question, questioner_id: @mj.id, questioner_type: :athlete, text: "Why do you do what you do?"
      @question.liked_by @kobe
      @question.liked_by @fan
      @reaction = create :post, content_type: "video", athlete_id: @kobe.id, status: :complete,
        parent_id: @question.id, parent_type: "Question"
      @question.athletes_tagged_list = [@lebron.id.to_s, @kobe.id.to_s]
      @question.save!
    end

    it "matches the proper schema on liked questions" do
      get "/api/v1/fans/#{@fan.id}/liked_questions",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      expect(response).to match_response_schema("questions")
    end
  end

  describe "metadata" do
    before(:example) do
      @fan = create :fan
      @athlete = create :athlete
    end

    it "matches the schema for an athlete's metadata" do
      get "/api/v1/athletes/#{@athlete.id}/metadata",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      expect(response).to match_response_schema("athlete_metadata")
    end

    it "matches the schema for a fan's metadata" do
      get "/api/v1/fans/#{@fan.id}/metadata",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      expect(response).to match_response_schema("fan_metadata")
    end
  end
end
