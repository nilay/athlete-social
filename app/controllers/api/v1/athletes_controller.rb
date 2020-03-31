class Api::V1::AthletesController < Api::V1::ApplicationController
  before_action :set_athlete, only: [:follow, :unfollow, :show]
  before_action :set_query, only: :index

  def index
    @athletes = Athlete.available_for_api.visible
      .search(@query)
      .result
      .order(last_name: :asc)
      .page(params[:page])
      .per(25)
  end

  def top
    @athletes = Athlete.available_for_api.visible
      .page(params[:page])
      .per(25)
  end

  def show
    if @athlete.all_blocked.include?(current_user) || current_user.all_blocked.include?(@athlete)
      error = ErrorSerializer.serialize({ blocked: "You are not allowed to view this athlete's profile." })
      render  json: error, status: :not_found
    end
  end

  def following
    @athletes = current_user.following_by_type("Athlete").available_for_api.visible
      .page(params[:page])
      .per(25)
  end

  def follow
    if AthleteFollower.call(@athlete, current_user)
      head :ok
    else
      error = ErrorSerializer.serialize({ follow: "Athlete could not be followed." })
      render json: error, status: :bad_request
    end
  end

  def unfollow
    if AthleteUnfollower.call(@athlete, current_user)
      head :ok
    else
      error = ErrorSerializer.serialize({ unfollow: "Athlete could not be unfollowed." })
      render json: error, status: :bad_request
    end
  end

  private

  def set_athlete
    @athlete = Athlete.available_for_api.visible.find(params[:id])
  end

  def set_query
    @query = {}
    @query[:first_name_or_last_name_cont_any] = params[:search].to_s.split(" ")
  end
end
