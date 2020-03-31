require "rails_helper"

RSpec.describe "Comment Requests", type: :request do
  let(:json) { JSON.parse(response.body) }

  describe "create" do
    before do
      @fan     = create :fan
      @athlete = create :athlete
      @post    = create :post, content_type: "image", thumbnail_url: "http://my_thumb.com"
    end

    before(:each) do
      Sidekiq::Worker.clear_all
    end

    context "as an athlete" do
      before do
        expect(@post.comments.count).to eq(0)
        expect(PushNotifierJob).to receive(:perform_in)
        post "/api/v1/comments",
          params: { commentable_type: "Post", commentable_id: @post.id, text: "This is a comment" }.to_json,
          headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json" }
      end

      it "creates the comment" do
        expect(response.status).to eq 201
        expect(response).to match_response_schema("post")
        expect(json["comments"].size).to eq(1)
      end
    end

    context "as commenting on your own post" do
      before do
        expect(@post.comments.count).to eq(0)
        expect(PushNotifierJob).not_to receive(:perform_in)
        post "/api/v1/comments",
          params: { commentable_type: "Post", commentable_id: @post.id, text: "This is a comment" }.to_json,
          headers: { "X-Athlete-Auth-Token" => @post.athlete.api_key, "Content-Type" => "application/json" }
      end

      it "creates the comment" do
        expect(response.status).to eq 201
        expect(response).to match_response_schema("post")
        expect(json["comments"].size).to eq(1)
      end
    end

    context "as a fan" do
      before do
        expect(@post.comments.count).to eq(0)
        post "/api/v1/comments",
          params: { commentable_type: "Post", commentable_id: @post.id, text: "This is a comment" }.to_json,
          headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "returns an unauthorized code" do
        expect(response.status).to eq 401
      end
    end

  end
end
