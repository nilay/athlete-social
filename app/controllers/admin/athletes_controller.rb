class Admin::AthletesController < Admin::ApplicationController
  load_and_authorize_resource
  before_action :set_query, only: :index
  before_action :set_active_athlete, only: [:show, :update, :deactivate, :invite]
  before_action :set_athlete, only: [:activate, :destroy]

  def index
    @athletes = Athlete.includes(posts: :reactions).search(@query).result
      .page(params[:page])
      .per(50)

    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json
    end
  end

  def invite
    if AthleteInviter.call(current_user, params[:email])
      head :ok
    else
      render json: { error: { message: "Could Not invite #{params[:email]}."} }
    end
  end

  def update
    if @athlete.update(athlete_params)
      head :ok
    else
      error = ErrorSerializer.serialize(@athlete.errors)
      render json: error, status: :bad_request
    end
  end

  def activate
    if @athlete.active!
      head :ok
    else
      error = ErrorSerializer.serialize(@athlete.errors)
      render json: error, status: :bad_request
    end
  end

  def deactivate
    if @athlete.inactive!
      head :ok
    else
      error = ErrorSerializer.serialize(@athlete.errors)
      render json: error, status: :bad_request
    end
  end

  def disable
    if @athlete.disable!
      head :ok
    else
      error = ErrorSerializer.serialize(@athlete.errors)
      render json: error, status: :bad_request
    end
  end

  def destroy
    if @athlete.destroy
      head :no_content
    else
      error = ErrorSerializer.serialize(@athlete.errors)
      render json: error, status: :bad_request
    end
  end

  private

  def set_active_athlete
    @athlete = Athlete.active.find(params[:id])
  end

  def set_athlete
    @athlete = Athlete.find(params[:id])
  end

  def set_query
    @query = {}
    @query[:first_name_or_last_name_cont_any] = params[:search].to_s.split(" ")
  end

end
