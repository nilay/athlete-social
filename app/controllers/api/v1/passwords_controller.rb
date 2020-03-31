class Api::V1::PasswordsController < Api::V1::ApplicationController
  before_action :ensure_valid_token, only: [:edit, :update]
  skip_before_action :api_authentication_required

  def create
    @user = Athlete.where(email: params[:user][:email]).first || Fan.where(email: params[:user][:email]).first
    if @user
      @user.deliver_password_reset_instructions!
      head :ok
    else
      render json: invalid_user,
             status: :unauthorized
    end
  end

  private

  def invalid_user
    ErrorSerializer.serialize({ email: "There was no user found by that email address." })
  end

  def permitted_params
    params.require(:user).permit(:password, :password_confirmation)
  end


end
