require "rails_helper"

RSpec.describe Api::V1::PasswordsController, type: :controller do

  let(:json) { JSON.parse(response.body) }
  let(:set_type_headers) {
    @request.headers["Content-Type"] = "application/json"
    @request.headers["Accept"] = "application/json"
  }

  before do
    set_type_headers
  end

  describe "#create" do
    before(:example) do
      @athlete = create :athlete
    end

    it "resets the athlete's password" do
      expect(@athlete.authenticate('test123')).to eq true
      expect(@athlete.authenticate('maryland66blobfish')).to eq false
      allow(Faker::Team).to receive(:state).and_return("Maryland")
      allow(Faker::Team).to receive(:creature).and_return("blobfish")
      allow(Random).to receive(:rand).with(99).and_return(66)
      post :create, params: { user: { email: @athlete.email } }
      expect(response.status).to eq(200)
      athlete = Athlete.where(email: @athlete.email).first
      expect(athlete.authenticate('test123')).to eq false
      expect(athlete.authenticate('maryland66blobfish')).to eq true
    end
  end

end
