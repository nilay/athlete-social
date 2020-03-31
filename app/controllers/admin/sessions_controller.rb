class Admin::SessionsController < Admin::ApplicationController
  skip_before_action :signin_required

  def new
    current_user_session.destroy
    @session = Challah::Session.new
  end

  def create
    @session = Challah::Session.new(request, params[:session])
    @session.ip = request.remote_ip

    if @session.save
      redirect_to return_to_path
    else
      redirect_to admin_signin_path, alert: "Sorry, that didn't work."
    end
  end

  def destroy
    current_user_session.destroy
    session[:return_to] = nil
    redirect_to admin_signin_path
  end

  def reset_password
    @title = "Pros | Password Reset"
    @password = ''
  end

  private


  def return_to_path
    result = session[:return_to]
    result = nil if result && result == "http://#{request.domain}/"
    if current_user.is_a? CmsAdmin
      result || admin_questions_path
    else
      result || polymorphic_url([current_user.class.to_s.underscore.pluralize, :profile])
    end
  end

end
