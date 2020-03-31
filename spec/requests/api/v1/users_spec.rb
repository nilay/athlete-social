require "rails_helper"

RSpec.describe "User Requests", type: :request do
  let(:json) { JSON.parse(response.body) }

  describe "#create" do
    context "as a fan" do
      context "with correct information" do
        before do
          post "/api/v1/sign-up",
          params: { email: "a@b.com", password: "test123", password_confirmation: "test123", first_name: "a", last_name: "b" }.to_json,
          headers: { "Content-Type" => "application/json" }
        end

        it "responds with the proper status code" do
          expect(response.status).to eq(201)
        end

        it "matches the correct response schema" do
          expect(response).to match_response_schema("authenticated_fan")
        end
      end

      context "with no passwords" do
        before do
          post "/api/v1/sign-up",
          params: { first_name: "Joe", last_name: "Bagels", email: "abc@abc.com" }.to_json,
          headers: { "Content-Type" => "application/json" }
        end

        it "responds with the proper status code" do
          expect(response.status).to eq(400)
        end

        it "responds that the password can't be blank" do
          expect(json["errors"].first["title"]).to eq("can't be blank")
        end
      end

      context "with short passwords" do
        before do
          post "/api/v1/sign-up",
          params: { first_name: "Joe", last_name: "Bagels", email: "abc@abc.com", password: "a", password_confirmation: "a" }.to_json,
          headers: { "Content-Type" => "application/json" }
        end

        it "responds with the proper status code" do
          expect(response.status).to eq(400)
        end

        it "responds that the password must be at least 4 letters" do
          expect(json["errors"].first["title"]).to eq("is not a valid password. Please enter at least 4 letters or numbers.")
        end
      end

      context "with non matching password and confirmation" do
        before do
          post "/api/v1/sign-up",
          params: { first_name: "Joe", last_name: "Bagels", email: "abc@abc.com", password: "abcde", password_confirmation: "efghi" }.to_json,
          headers: { "Content-Type" => "application/json" }
        end

        it "responds with the proper status code" do
          expect(response.status).to eq(400)
        end

        it "responds that the password and confirmation must match" do
          expect(json["errors"].first["title"]).to eq("does not match the confirmation password.")
        end
      end

      context "with a malformed email address" do
        before do
          post "/api/v1/sign-up",
          params: { first_name: "Joe", last_name: "Bagels", email: "abc.com", password: "asdf", password_confirmation: "asdf" }.to_json,
          headers: { "Content-Type" => "application/json" }
        end

        it "responds with 400" do
          expect(response.status).to eq(400)
        end

        it "tells you the email is not correct" do
          expect(json["errors"].first["title"]).to eq("is not a valid email address.")
        end
      end
    end
    context "as an athlete" do
      before do
        @athlete = create :athlete
        @email   = "test@example.com"
        @invitation = AthleteInviter.call(@athlete, email: @email)
        @invitation.save
        post "/api/v1/sign-up",
        params: { email: "test@example.com",
                  password: "asdf", password_confirmation: "asdf",
                  first_name: "Joe", last_name: "Bagels",
                  invite_token: @invitation.invite_token }.to_json,
        headers: { "Content-Type" => "application/json"}
      end

      it "responds with 201" do
        expect(response.status).to eq(201)
      end

      it "responds with the proper schema" do
        expect(response).to match_response_schema("authenticated_athlete")
      end

      it "creates an athlete with an invite token attached" do
        user = Athlete.find_by_email("test@example.com")
        expect(@athlete.invitees).to include(user)
      end
    end

    context "new athlete with bad token" do
      before do
        @athlete = create :athlete
        @email = "test@example.com"
        @bad_token = "OU812"

        post "/api/v1/sign-up",
        params: { email: "test@example.com",
                  password: "asdf", password_confirmation: "asdf",
                  first_name: "Joe", last_name: "Bagels",
                  invite_token: @bad_token }.to_json,
        headers: { "Content-Type" => "application/json" }
      end

      it "responds with 401" do
        expect(response.status).to eq(401)
      end
    end
  end

  describe "#send_invite" do
    context "as a fan" do
      before do
        @fan = create :fan
        post "/api/v1/users/send_invite",
        params: { email: "test@example.com" }.to_json,
        headers: { "X-Fan-Auth-Token" => @fan.api_key, "Content-Type" => "application/json" }
      end

      it "responds with the right error code" do
        expect(response.status).to eq 401
      end
    end

    context "as a cms user" do
      before do
        @cms_user = create :cms_admin
        post "/api/v1/users/send_invite",
        params: { email: "test@example.com" }.to_json,
        headers: { "X-Cms-Admin-Auth-Token" => @cms_user.api_key, "Content-Type" => "application/json" }
      end

      it "responds with a 204" do
        expect(response.status).to eq(204)
      end
    end

    context "as an athlete" do
      before do
        @athlete = create :athlete
        @athlete2 = create :athlete
      end

      context "as a good request" do
        before do
          post "/api/v1/users/send_invite",
          params: { email: "test@example.com" }.to_json,
          headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json"}
        end

        it "responds with a 204" do
          expect(response.status).to eq(204)
        end
      end

      context "to an already existing athlete" do
        before do
          post "/api/v1/users/send_invite",
          params: { email: @athlete2.email }.to_json,
          headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json"}
        end

        it "responds with a 400" do
          expect(response.status).to eq(400)
        end

        it "responds with an error indicating the athlete already exists" do
          expect(json["errors"].first["id"]).to eq("athlete")
          expect(json["errors"].first["title"]).to eq("#{@athlete2.email} has already joined Pros.")
        end

      end

      context "to a bad email address" do
        before do
          post "/api/v1/users/send_invite", params: { email: "test.example.com" }.to_json,
          headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json" }
        end

        it "responds with a 400" do
          expect(response.status).to eq(400)
        end

        it "responds with an error indicating phone number is the wrong length" do
          expect(json["errors"].first["id"]).to eq("email")
          expect(json["errors"].first["title"]).to eq("email must be in valid format.")
        end
      end

      context "invite by phone" do

        context "with a good number" do
          before do
            post "/api/v1/users/send_invite",
            params: { phone_number: "7045551212", name: "Ray Johnson" }.to_json,
            headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json" }
          end

          it "responds with a 204" do
            expect(response.status).to eq(204)
          end
        end

        context "with a bad number" do
          before do
            post "/api/v1/users/send_invite",
            params: { phone_number: "704555", name: "Ray Johnson" }.to_json,
            headers: { "X-Athlete-Auth-Token" => @athlete.api_key, "Content-Type" => "application/json" }
          end

          it "responds with a 400" do
            expect(response.status).to eq(400)
          end

          it "responds with an error indicating phone number is the wrong length" do
            expect(json["errors"].first["id"]).to eq("phone_number")
            expect(json["errors"].first["title"]).to eq("phone number must be area code and phone number.")
          end
        end
      end
    end
  end
end
