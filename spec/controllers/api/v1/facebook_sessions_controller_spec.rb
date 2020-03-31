require "rails_helper"

describe Api::V1::FacebookSessionsController, type: :controller do
  let(:set_type_headers) {
    @request.headers["Content-Type"] = "application/json"
    @request.headers["Accept"] = "application/json"
  }

  after(:context) do
    Fan.destroy_all
  end

  before do
    set_type_headers
    @facebook_session_params = { code: '123078q345907234dfukjsdfg' }
    @fb_user_hash = { 'first_name' => 'Patrick', 'last_name' => 'Lewis', 'email' => 'patrick@ovenbits.com' }
  end


  describe "valid FB user" do
    it "should login" do
      user = create :fan
      allow(Challah::Facebook::Interface).to receive(:get_extended_token).and_return('123078q345907234dfukjsdfg-ovenbits_test_token')
      allow(Challah::Facebook::Interface).to receive(:get_user_info_from_access_token).and_return(@fb_user_hash)
      allow_any_instance_of(Challah::Session).to receive(:valid?).and_return true
      allow_any_instance_of(Challah::Session).to receive(:user).and_return user
    end
  end

  describe "invalid FB user" do
    it "should not login" do
      stub_request(:get, "https://graph.facebook.com/me?access_token=123078q345907234dfukjsdfg")
        .with(:headers => {'Accept'=>'*/*', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Faraday v0.9.2'})
        .to_return(:status => 401, :body => "", :headers => {})
      @fb_error = Koala::Facebook::APIError.new(401, nil)
      allow_any_instance_of(Challah::Authenticators::Facebook).to receive(:get_user_info_from_access_token).and_raise(@fb_error)

      allow(Challah::Facebook::Interface).to receive(:get_extended_token).and_return('123078q345907234dfukjsdfg-ovenbits_test_token')
      allow(Challah::Facebook::Interface).to receive(:get_user_info_from_access_token).and_return(@fb_user_hash)

      post :create, params: @facebook_session_params.merge(format: :json)
      expect(response.status).to eq(400)
    end
  end
end
