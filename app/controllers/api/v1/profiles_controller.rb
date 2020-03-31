class Api::V1::ProfilesController < Api::V1::ApplicationController
  before_action :set_user, only: [:following, :followers, :reactions, :answers,
                                  :metadata, :liked_posts, :liked_questions]
  before_action :blocked_users_not_found, only: [:following, :followers, :reactions,
                                                 :answers, :metadata, :liked_posts, :liked_questions]

  def me
    @me = current_user
  end

  def update
    if current_user.update(current_user_params)
      if params[:image_guid]
        AvatarDownloadJob.perform_async(current_user.avatar.id, params[:image_guid])
      end
      head :ok
    else
      error = ErrorSerializer.serialize(current_user.errors)
      render json: error, status: :bad_request
    end
  end

  def following
    @athletes = @user.following_by_type("Athlete").available_for_api.visible.page(params[:page]).per(25)
  end

  def followers
    @athletes = @user.followers_by_type("Athlete").available_for_api.visible.page(params[:page]).per(25)
  end

  def reactions
    head 401 and return unless current_user.class == Athlete
    @posts = @user.reactions.page(params[:page]).per(25)
  end

  def answers
    @answers = @user.answers.page(params[:page]).per(25)
  end

  def liked_posts
    @posts = @user.get_up_voted(Post).original.page(params[:page]).per(25)
  end

  def liked_questions
    @questions = @user.get_up_voted(Question).page(params[:page]).per(25)
  end

  def metadata
    @metadata = @user.metadata(current_user)
  end

  private

  def current_user_params
    #The iOS app is passing a camelCased passwordConfirmation instead of the
    #usual underscore.  This went unnoticed at launch because we weren't validating
    #using Challah's built in validators, but when we turned them on, this became
    #an issue.
    params[:password_confirmation] ||= params[:passwordConfirmation]
    params.permit(:first_name, :last_name, :email, :password, :password_confirmation)
  end

  def not_found
    render json: ErrorSerializer.serialize({ not_found: "You cannot access this profile." }), status: :not_found
  end

  def set_user
    models = { athlete_id: Athlete, fan_id: Fan, brand_id: Brand }
    type   = [:athlete_id, :fan_id, :brand_id].find {|x| params[x] }
    @user  ||= models[type].find(params[type])
  end

  def blocked_users_not_found
    set_user
    not_found if (@user.all_blocked.include?(current_user) || current_user.all_blocked.include?(@user))
  end

end
