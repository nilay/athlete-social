require "rails_helper"

RSpec.describe "Questions Requests", type: :request do

  let(:json) { JSON.parse(response.body) }

  describe "GET calls" do
    before do
      Athlete.destroy_all
      Fan.destroy_all
      Question.destroy_all
      @fan      = create :fan
      @athlete  = create :athlete
      @athlete2 = create :athlete
      create_list(:question, 15, :with_reactions, questioner_id: [@athlete.id, @athlete2.id].sample, questioner_type: "athlete")
      create_list(:question, 10, questioner_id: [@athlete.id, @athlete2.id].sample, questioner_type: "athlete")
    end

    after do
      Athlete.destroy_all
      Fan.destroy_all
      Question.destroy_all
    end

    describe "#index" do
      context "as a fan" do
        before do
          get "/api/v1/questions",
          headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
        end

        it "responds with the proper code" do
          expect(response.status).to eq 200
        end

        it "responds with the proper schema" do
          expect(response).to match_response_schema("questions")
        end

        it "responsds with ONLY the answered questions" do
          expect(json["questions"].count).to eq(Question.answered.count)
        end
      end

      context "as an athlete" do
        before do
          get "/api/v1/questions",
          headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json" }
        end

        it "responds with the proper code" do
          expect(response.status).to eq 200
        end

        it "responds with the proper schema" do
          expect(response).to match_response_schema("questions")
        end

        it "responsds with all questions" do
          expect(json["questions"].count).to eq(Question.all.count)
        end

      end
    end

    describe "#show" do
      before do
        get "/api/v1/questions/#{Question.last.id}",
        headers: { "X-Athlete-Auth-Token" => @athlete2.api_key, "Content-Type" => "application/json" }
      end

      it "returns the proper response code" do
        expect(response.status).to eq 200
      end

      it "returns the proper schema" do
        expect(response).to match_response_schema("question")
      end
    end
  end

  describe "#create" do
    before do
      @fan                 = create :fan
      @athlete             = create :athlete
      @athlete2            = create :athlete
      @athlete2.follow @athlete
      @question_params     = { text: "test question?" }
      @question_tag_params = @question_params.merge(tags: ["#awesome", "#gnarly", @athlete2.id.to_s])
    end
    context "as a fan" do
      before do
        post "/api/v1/questions",
          params: { question: @question_params }.to_json,
          headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "brings you bad juju to try and create a question as a fan" do
        expect(response.status).to eq 401
      end
    end

    context "as an athlete" do
      before do
        post "/api/v1/questions",
          params: { question: @question_params }.to_json,
          headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json" }
      end

      it "returns the proper response" do
        expect(response.status).to eq 201
      end

      it "creates a question" do
        expect(@athlete.questions.where(text: "test question?")).not_to be_empty
      end
    end

    context "as an athlete with tags" do
      before do
        expect(PushNotifierJob).to receive(:perform_async).exactly(2).times
        post "/api/v1/questions",
          params: { question: @question_tag_params }.to_json,
          headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json" }
      end

      it "returns the proper response code" do
        expect(response.status).to eq 201
      end

      it "adds tagged athletes to questions" do
        expect(Question.last.tagged_athletes).to include(@athlete2)
      end

      it "adds hashtags to questions" do
        expect(Question.last.hashtag_list).to include("#awesome", "#gnarly")
      end
    end
  end

  describe "#update" do
    before do
      @question = create :question, :with_athlete
      @update_params = { text: "updated question text?" }
    end
    context "as the athlete who created the question" do
      before do
        patch "/api/v1/questions/#{@question.id}",
        params: @update_params.to_json,
        headers: { "X-Athlete-Auth-Token" => @question.athlete.api_key, "Content-Type" => "application/json" }
      end

      it "responds with the proper status code" do
        expect(response.status).to eq 200
      end

      it "updates the question with params" do
        @question.reload
        expect(@question.text).to eq "updated question text?"
      end
    end
    context "as a random athlete" do
      before do
        @athlete2 = create :athlete
        patch "/api/v1/questions/#{@question.id}",
        params: @update_params.to_json,
        headers: { "X-Athlete-Auth-Token" => @athlete2.api_key, "Content-Type" => "application/json" }
      end

      it "responds with the proper response code" do
        expect(response.status).to eq 401
      end
    end
  end

  describe "#destroy" do
    before do
      @question = create :question, :with_athlete
    end

    context "as the owning athlete" do
      before do
        delete "/api/v1/questions/#{@question.id}",
        headers: { "X-Athlete-Auth-Token" => @question.athlete.api_key, "Content-Type" => "application/json" }
      end

      it "responds with the right response code" do
        expect(response.status).to eq 204
      end

      it "deletes the question" do
        @question.reload
        expect(@question.status).to eq "archived"
      end
    end

    context "as a random athlete" do
      before do
        @athlete2 = create :athlete
        delete "/api/v1/questions/#{@question.id}",
        headers: { "X-Athlete-Auth-Token" => @athlete2.api_key, "Content-Type" => "application/json" }
      end

      it "responds with the right response code" do
        expect(response.status).to eq 401
      end

      it "deletes the question" do
        @question.reload
        expect(@question.status).not_to eq "archived"
      end
    end
  end

  describe "#like" do

    before do
      @question = create :question, :with_athlete
    end

    describe "as a fan" do
      before do
        @fan = create :fan
        post "/api/v1/questions/#{@question.id}/like",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "allows a fan to like a question" do
        expect(@question.get_likes.size).to eq 1
      end

      it "returns the proper response code" do
        expect(response.status).to eq 200
      end
    end

    describe "as an athlete" do
      before do
        @athlete = create :athlete
        post "/api/v1/questions/#{@question.id}/like",
        headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json" }
      end

      it "allows an athlete to like a question" do
        expect(@question.get_likes.size).to eq 1
      end

      it "returns the proper response code" do
        expect(response.status).to eq 200
      end
    end
  end

  describe "#unlike" do

    before do
      @question = create :question, :with_athlete
    end

    describe "as a fan" do
      before do
        @fan = create :fan
        ContentLiker.call(@question, @fan)
        post "/api/v1/questions/#{@question.id}/unlike",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "allows a fan to unlike a question" do
        expect(@question.get_likes.size).to eq 0
      end

      it "returns the proper response code" do
        expect(response.status).to eq 200
      end
    end

    describe "as an athlete" do
      before do
        @athlete = create :athlete
        ContentLiker.call(@question, @athlete)
        post "/api/v1/questions/#{@question.id}/unlike",
        headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json" }
      end

      it "allows an athlete to unlike a question" do
        expect(@question.get_likes.size).to eq 0
      end

      it "returns the proper response code" do
        expect(response.status).to eq 200
      end
    end
  end

  describe "#dislike" do

    before do
      @question = create :question, :with_athlete
    end

    describe "as a fan" do
      before do
        @fan = create :fan
        post "/api/v1/questions/#{@question.id}/dislike",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "allows a fan to dislike a question" do
        expect(@question.get_dislikes.size).to eq 1
      end

      it "returns the proper response code" do
        expect(response.status).to eq 200
      end
    end

    describe "as an athlete" do
      before do
        @athlete = create :athlete
        post "/api/v1/questions/#{@question.id}/dislike",
        headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json" }
      end

      it "allows an athlete to disike a question" do
        expect(@question.get_dislikes.size).to eq 1
      end

      it "returns the proper response code" do
        expect(response.status).to eq 200
      end
    end
  end

  describe "#undislike" do

    before do
      @question = create :question, :with_athlete
    end

    describe "as a fan" do
      before do
        @fan = create :fan
        ContentDisliker.call(@question, @fan)
        post "/api/v1/questions/#{@question.id}/undislike",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "allows a fan to unlike a question" do
        expect(@question.get_dislikes.size).to eq 0
      end

      it "returns the proper response code" do
        expect(response.status).to eq 200
      end
    end

    describe "as an athlete" do
      before do
        @athlete = create :athlete
        ContentDisliker.call(@question, @athlete)
        post "/api/v1/questions/#{@question.id}/undislike",
        headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json" }
      end

      it "allows an athlete to unlike a question" do
        expect(@question.get_dislikes.size).to eq 0
      end

      it "returns the proper response code" do
        expect(response.status).to eq 200
      end
    end
  end
end
