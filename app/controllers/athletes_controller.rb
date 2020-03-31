class AthletesController < ApplicationController
  skip_before_action :verify_authenticity_token, except: [ :create, :new ]

  def new
    session[:invite_token] = params[:id]
    @athlete = Athlete.new
    @title = "Pros | Sign up"
    render layout: 'admin/application'
  end

  def create
    current_user_session.destroy
    @athlete = Athlete.new(athlete_params)
    if @athlete.save
      @athlete.associate_invite_token(params[:athlete][:invite_token])
      @session = Challah::Session.new(request, { username: @athlete.email, password: params[:athlete][:password]})
      if @session.save
        begin_follow_jobs(@athlete)
        session[:invite_token] = nil
        redirect_to ENV["SUCCESSFUL_SIGNUP_URL"]
      else
        redirect_to :new_athlete, alert: "Could not be logged in."
      end
    else
      if @athlete.errors[:email].include?("has already been taken")
        redirect_to :new_athlete, alert: "There is already an account with this email address. To sign in, go to the app.  If you have forgotten your password,
          click #{view_context.link_to('here', admin_passwords_path)}!".html_safe
      else
        redirect_to :new_athlete, alert: "We couldn't sign you up... #{@athlete.errors.full_messages.to_sentence}"
      end
    end
  end

  def deactivate
    @athlete = Athlete.find(params[:id])
    if @athlete.inactive!
      head :ok
    else
      error = ErrorSerializer.serialize(@athlete.errors)
      render json: error, status: :bad_request
    end
  end

  def disable
    @athlete = Athlete.find(params[:id])
    if @athlete.disabled!
      head :ok
    else
      error = ErrorSerializer.serialize(@athlete.errors)
      render json: error, status: :bad_request
    end
  end

  def enable
    @athlete = Athlete.find(params[:id])
    if @athlete.enabled!
      head :ok
    else
      error = ErrorSerializer.serialize(@athlete.errors)
      render json: error, status: :bad_request
    end
  end

  def new_from_facebook
    redirect_to Challah::Facebook::Interface.get_authorization_url(create_from_facebook_athletes_url, params[:permissions])
  end

  def create_from_facebook
    begin
      access_token = Challah::Facebook::Interface.get_access_token_for_oauth_code(params[:code], create_from_facebook_athletes_url)
      fb_uid = Challah::Facebook::Interface.get_facebook_uid_from_access_token(access_token)
      if user = Challah::Authenticators::Facebook.authenticate(fb_uid: fb_uid, fb_user_access_token: access_token, current_user: current_user, user_type: :athlete)
        @session = Challah::Session.create!(user, request, nil, Athlete)
        @session.user.associate_invite_token(session[:invite_token])
        session[:invite_token] = nil
        begin_follow_jobs(@session.user)
        redirect_to ENV["SUCCESSFUL_SIGNUP_URL"]
      else
        redirect_to :new_athlete_path, alert: "Could not be logged in."
      end
    rescue ActiveRecord::RecordInvalid => e
      ReportError.call(exception: e)
      redirect_to :new_athlete_path, alert: "Could not be logged in... #{@session.user.errors.full_messages}."
    end
  end

  private

  def athlete_params
    params.require(:athlete).permit([:first_name, :last_name, :email, :password, :password_confirmation])
  end

  def begin_follow_jobs(athlete)
    NewAthleteFollowingJob.perform_async(athlete.id)
    AutoFollowerJob.new.perform(athlete.id, athlete.class)
  end
end
