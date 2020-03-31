class Api::V1::UsersController < Api::V1::ApplicationController
  skip_before_action :api_authentication_required, only: :create

  # POST /sign-up
  def create
    @user_resource = build_user_resource
    if @user_resource
      if @user_resource.valid?
        AutoFollowerJob.new.perform(@user_resource.id, @user_resource.class)
        render status: :created
      else
        render json: ErrorSerializer.serialize(@user_resource.errors.messages), status: 400
      end
    else
      render json: ErrorSerializer.serialize({ create: "You must have a valid invite token to join" }), status: 401
    end
  end

  # POST /users/send_invite
  def send_invite
    if can? :create, Invitation
      @invitation = AthleteInviter.call(current_user, params)
      if @invitation.save
        head :no_content
      else
        error = ErrorSerializer.serialize(@invitation.errors)
        render json: error, status: :bad_request
      end
    else
      render json: ErrorSerializer.serialize({ send_invite: "Only Athletes are allowed to perform this action" }), status: 401
    end
  end

  def deactivate
    current_user.disabled!
    head :no_content
  end

  def activate
    current_user.enabled!
    head :no_content
  end

  def block_user
    if UserBlocker.will_allow_block?(current_user.id, current_user.class.to_s, params[:user_id], params[:user_type])
      UserBlockerJob.perform_async(current_user.id, current_user.class.to_s, params[:user_id], params[:user_type])
      head :ok
    else
      render json: ErrorSerializer.serialize({ block: "User could not be blocked." }), status: 400
    end
  end

  private

  def athlete_ids
    Athlete.all.limit(25).pluck(:id)
  end

  def build_user_resource
    if params[:invite_token]
      process_as_athlete(params[:invite_token], user_params)
    else
      process_as_fan(user_params)
    end
  end

  # TODO: This maybe should be in a service class? DPS 2016-02-10
  def process_as_athlete(token, params)
    invitation = Invitation.find_by_invite_token(token)
    if invitation
      athlete = Athlete.create(params)
      invitation.invitee = athlete
      invitation.save
      athlete
    end
  end

  def process_as_fan(params)
    Fan.create(params)
  end

  def user_params
    params.permit([:name, :phone_number, :email, :first_name, :last_name, :password,
                   :password_confirmation, :invite_token])
  end
end
