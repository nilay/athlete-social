require "rails_helper"

RSpec.describe "Athlete Requests", type: :request do
  let(:json) { JSON.parse(response.body) }

  describe "index actions" do
    before do
      Athlete.destroy_all
      Fan.destroy_all
      @fan      = create :fan
      @athletes = create_list(:athlete, 26)
    end

    after do
      Athlete.destroy_all
      Fan.destroy_all
    end

    context "page 1" do
      before do
        get "/api/v1/athletes",
          headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "matches our response schema for athletes" do
        expect(response).to match_response_schema("athletes")
      end

      it "responds with the proper status code" do
        expect(response.status).to eq 200
      end

      it "has no previous links on the first page" do
        expect(json["links"]["previous"]).to be_nil
      end

      it "responds with a list of athletes" do
        expect(json["athletes"].count).to eq(25)
      end
    end

    context "page 2" do
      before do
        get "/api/v1/athletes?page=2",
          headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "matches our response schema for athletes" do
        expect(response).to match_response_schema("athletes")
      end

      it "responds with the proper status code" do
        expect(response.status).to eq 200
      end

      it "has no next links on the last page" do
        expect(json["links"]["next"]).to be_nil
      end

      it "responds with the second page of athletes" do
        expect(json["athletes"].count).to eq(1)
      end
    end

    context "searching for a user" do
      before do
        get "/api/v1/athletes?search=#{@athletes.first.first_name}",
          headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "searches for an athlete" do
        expect(json["athletes"].select{ |a| a["first_name"] }.empty?).to be false
      end
    end

  end

  describe "Top Athletes API" do
    before do
      Athlete.destroy_all
      Fan.destroy_all
      @fan      = create :fan
      @athletes = create_list(:athlete, 5)
      get "/api/v1/athletes/top",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
    end

    after do
      Athlete.destroy_all
      Fan.destroy_all
    end

    it "returns the proper status code" do
      expect(response.status).to eq 200
    end

    it "retrieves a list of athletes" do
      expect(response).to match_response_schema("athletes")
    end
  end

  describe "show" do
    before do
      @athlete = create :athlete
      @other   = create :athlete
      @fan     = create :fan
    end

    context "as a fan" do
      before do
        get "/api/v1/athletes/#{@athlete.id}",
          headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "returns the proper status code" do
        expect(response.status).to eq 200
      end

      it "returns the proper schema" do
        expect(response).to match_response_schema("athlete")
      end
    end

    context "as a blocked fan" do
      before do
        @athlete.create_block(@fan)
        get "/api/v1/athletes/#{@athlete.id}",
          headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "returns a 404 if the fan has been blocked" do
        expect(response.status).to eq 404
      end

    end

    context "as an athlete" do
      before do
        get "/api/v1/athletes/#{@athlete.id}",
          headers: { "X-Athlete-Auth-Token" => @other.api_key, "Content-Type" => "application/json" }
      end

      it "returns the proper status code" do
        expect(response.status).to eq 200
      end

      it "returns the proper schema" do
        expect(response).to match_response_schema("athlete")
      end
    end

    context "as a blocked athlete" do
      before do
        @athlete.create_block(@other)
        get "/api/v1/athletes/#{@athlete.id}",
          headers: { "X-Athlete-Auth-Token" => @other.api_key, "Content-Type" => "application/json" }
      end

      it "returns a 404 if the fan has been blocked" do
        expect(response.status).to eq 404
      end
    end
  end

  describe "#following" do
    before do
      @athlete1 = create :athlete
      @athlete2 = create :athlete
      @fan = create :fan
      AthleteFollower.call(@athlete1, @fan)
      AthleteFollower.call(@athlete2, @fan)
      get "/api/v1/athletes/following",
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
    end

    after do
      Athlete.destroy_all
      Fan.destroy_all
    end

    it "returns the proper status code" do
      expect(response.status).to eq 200
    end

    it "returns the proper count of athletes following" do
      expect(json["athletes"].count).to eq 2
    end

    it "returns athletes using the proper JSON schema" do
      expect(response).to match_response_schema("athletes")
    end
  end

  describe "#follow" do
    before do
      @athlete1 = create :athlete
      @athlete2 = create :athlete
      @fan      = create :fan
    end

    after do
      Athlete.destroy_all
      Fan.destroy_all
    end

    context "as a fan" do
      before do
        post "/api/v1/athletes/#{@athlete1.id}/follow.json",
          headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "returns the proper response code" do
        expect(response.status).to eq 200
      end

      it "added a follower to the athlete" do
        expect(@athlete1.followers.size).to eq 1
      end

      it "creates a follow relationship between the two athletes" do
        expect(@athlete1.followed_by?(@fan)).to be true
      end
    end

    context "as an athlete" do
      before do
        post "/api/v1/athletes/#{@athlete1.id}/follow.json",
          headers: { "X-Athlete-Auth-Token" => @athlete2.api_key, "Content-Type" => "application/json" }
      end

      it "returns the proper response code" do
        expect(response.status).to eq 200
      end

      it "added a follower to the athlete" do
        expect(@athlete1.followers.size).to eq 1
      end

      it "creates a follow relationship between the two athletes" do
        expect(@athlete1.followed_by?(@athlete2)).to be true
      end
    end
  end

  describe "unfollowing" do
    before do
      @athlete1 = create :athlete
      @athlete2 = create :athlete
      @fan      = create :fan
      @athlete2.follow(@athlete1)
      @fan.follow(@athlete1)
    end

    context "as a fan" do
      before do
        expect(@athlete1.followed_by?(@fan)).to be true
        post "/api/v1/athletes/#{@athlete1.id}/unfollow.json",
          headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "returns the proper response code" do
        expect(response.status).to eq 200
      end

      it "unfollows the athlete" do
        expect(@athlete1.followed_by?(@fan)).to be false
      end
    end

    context "as a fan" do
      before do
        expect(@athlete1.followed_by?(@athlete2)).to be true
        post "/api/v1/athletes/#{@athlete1.id}/unfollow.json",
          headers: { "X-Athlete-Auth-Token" => @athlete2.api_key, "Content-Type" => "application/json" }
      end

      it "returns the proper response code" do
        expect(response.status).to eq 200
      end

      it "unfollows the athlete" do
        expect(@athlete1.followed_by?(@athlete2)).to be false
      end
    end
  end

end
