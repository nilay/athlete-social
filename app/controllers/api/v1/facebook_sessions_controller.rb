class Api::V1::FacebookSessionsController < Api::V1::ApplicationController
  skip_before_action :check_request_format
  skip_before_action :api_authentication_required

  def new
    redirect_to Challah::Facebook::Interface.get_authorization_url(api_v1_create_facebook_session_url, params[:permissions])
  end

  def create
    begin
      user_hash = Challah::Facebook::Interface.get_user_object_from_access_token(params[:code])
      if user = Challah::Authenticators::Facebook.authenticate(fb_uid: user_hash["id"], fb_user_access_token: params[:code], current_user: current_user)
        @session = Challah::Session.create!(user, request, nil, user.class)
        render status: :ok
      else
        head :bad_request
      end
    rescue => e
      ReportError.call(exception: e)
      puts e
      head :bad_request
    end
  end

  private

  def facebook_session_params
    params.permit(:provider, :fb_uid, :fb_user_access_token)
  end
end
