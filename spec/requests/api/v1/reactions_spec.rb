require "rails_helper"

RSpec.describe "Reaction Requests", type: :request do
  let(:json) { JSON.parse(response.body) }

  before do
    @fan      = create :fan
    @question = create :question, :with_athlete, :with_reactions
    @post     = create :post, :video, :with_comments, :with_tags, :with_reactions
  end

  describe "reactions to a post" do
    context "as a reaction to a post" do
      before do
        get "/api/v1/posts/#{@post.id}/reactions/#{@post.reactions.first.id}",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "responds with the proper response code" do
        expect(response.status).to eq 200
      end

      it "responds with the proper response schema" do
        expect(response).to match_response_schema("reaction_to_post")
      end

    end
  end

  describe "reactions to a question" do
    context "as a reaction to a question" do
      before do
        get "/api/v1/questions/#{@question.id}/reactions/#{@question.reactions.first.id}",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "responds with the proper response code" do
        expect(response.status).to eq 200
      end

      it "responds with the proper response schema" do
        expect(response).to match_response_schema("reaction_to_question")
      end

    end
  end
end
