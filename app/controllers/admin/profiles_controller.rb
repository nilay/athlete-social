class Admin::ProfilesController < Admin::ApplicationController
  def me
    @me = current_user
  end

  def edit
    @me = current_user
  end

  def update
    if current_user.update(current_user_params)
      redirect_to profile_path, notice: "Your details were saved!"
    else
      redirect_to profile_path, alert: "Your profile could not be updated ... #{current_user.errors.full_messages}"
    end
  end

  private

  def current_user_params
    params.permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end
end
