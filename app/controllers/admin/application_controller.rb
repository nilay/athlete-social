class Admin::ApplicationController < ActionController::Base
  before_action :signin_required

  layout "admin/application"

  def signin_required
    unless signed_in?
      session[:return_to] = request.url
      redirect_to admin_signin_path and return
    end
  end
end
