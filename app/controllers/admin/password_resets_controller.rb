class Admin::PasswordResetsController < Admin::ApplicationController
  skip_before_action :signin_required

  def index
    @title = "Pros | Password Reset"
    @password_reset = PasswordReset.new
  end

  def create
    email = params[:password_reset][:email]

    if user = CmsAdmin.find_by(email: email)
      password_reset = PasswordReset.new(user: user)
      password_reset.save
      user.deliver_password_reset_instructions!(password_reset)
    end
  end

  def show
    @password_reset = PasswordReset.find(params[:id])

    if @password_reset.user_gid.blank?
      redirect_to admin_questions_path
    end
  end

  def update
    @password_reset = PasswordReset.find(params[:id])

    if user = @password_reset.user
      if user.update(user_password_params)
        @password_reset.clear!
        render :update
      else
        flash.now[:alert] = "There was a problem updating your password: #{user.errors.full_messages.to_sentence}"
        render :show
      end
    else
      redirect_to admin_questions_path
    end
  end

  private

  def user_password_params
    params.require(:password_reset).permit(:password, :password_confirmation)
  end
end
