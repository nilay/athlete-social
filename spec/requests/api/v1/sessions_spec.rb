require "rails_helper"

RSpec.describe "Session Requests", type: :request do
  let(:json) { JSON.parse(response.body) }

  describe "successful sign in" do

    context "as a fan" do
      before do
        @fan = create :fan
        post '/api/v1/sign-in',
          params: { email: @fan.email, password: "test123" }.to_json,
          headers: { "Content-Type" => "application/json" }
      end

      it "responds with the right status code" do
        expect(response.status).to eq(200)
      end

      it "responds with a fan object" do
        expect(response).to match_response_schema("authenticated_fan")
      end

      it "responds with the right fan" do
        expect(json["fan"]["first_name"]).to eq(@fan.first_name)
      end
    end

    context "as an athlete" do
      before do
        @athlete = create :athlete
        post '/api/v1/sign-in',
          params: { email: @athlete.email, password: "test123" }.to_json,
          headers: { "Content-Type" => "application/json" }
      end

      it "responds with the right status code" do
        expect(response.status).to eq(200)
      end

      it "responds with an athlete object" do
        expect(response).to match_response_schema("authenticated_athlete")
      end

      it "responds with the right athlete" do
        expect(json["athlete"]["first_name"]).to eq(@athlete.first_name)
      end
    end
  end

  describe "unsuccessful sign in" do
    context "as a fan" do
      before do
        @fan = create :fan
        post '/api/v1/sign-in',
          params: { email: @fan.email, password: "test1234" }.to_json,
          headers: { "Content-Type" => "application/json" }
      end

      it "responds with the right status code" do
        expect(response.status).to eq(401)
      end

      it "responds with the right error" do
        expect(json["errors"].first["title"]).to eq("There was a problem signing in to your account. Check your credentials and try again.")
      end

    end
    context "as an athlete" do
      before do
        @athlete = create :athlete
        post '/api/v1/sign-in',
          params: { email: @athlete.email, password: "test1234" }.to_json,
          headers: { "Content-Type" => "application/json" }
      end

      it "responds with the right status code" do
        expect(response.status).to eq(401)
      end

      it "responds with the right error" do
        expect(json["errors"].first["title"]).to eq("There was a problem signing in to your account. Check your credentials and try again.")
      end
    end
  end

end
