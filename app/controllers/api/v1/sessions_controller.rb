class Api::V1::SessionsController < Api::V1::ApplicationController
  skip_before_action :api_authentication_required, only: :create

  # POST /sign-in
  def create
    @session = Challah::Session.new(request, session_params)
    if @session.valid?
      current_user.enabled!
      render status: :ok
    else
      render json: invalid_session,
             status: :unauthorized
    end
  end

  # DELETE /sign-out
  def destroy
    destroy_session

    head :no_content
  end

  private

  def destroy_session
    current_user.try(:update, api_key: nil)
  end

  def invalid_session
    ErrorSerializer.serialize({ session: "There was a problem signing in to your account. Check your credentials and try again." })
  end

  def response_hash
    {@session.user.class.to_s.underscore.to_sym => @session.user }
  end

  def session_params
    {
      username: (params[:email] || params[:username]).to_s.downcase.strip,
      password: params[:password].to_s
    }
  end
end
