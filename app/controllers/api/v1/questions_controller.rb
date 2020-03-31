class Api::V1::QuestionsController < Api::V1::ApplicationController
  load_and_authorize_resource except: :index
  before_action :set_question, only: [:update, :destroy, :like, :dislike, :show]

  def index
    @questions = set_questions
      .order('created_at DESC')
      .page(params[:page])
      .per(25)

    if params[:athlete_id]
      @questions = @questions.where(questioner_id: params[:athlete_id], questioner_type: 'athlete')
    elsif params[:brand_id]
      @questions = @questions.where(questioner_id: params[:brand_id], questioner_type: 'brand_user')
    end

  end

  def show
  end

  def create
    @question = current_user.build_question(question_params)
    if @question.save
      PushNotifierJob.perform_async(current_user.follower_ids_by_type('Athlete'), "#{current_user.name} added a new question!", "pros://questions/#{@question.id}")
      MediaTagger.call(@question.id, "question", params[:question][:tags]) if params[:question][:tags]
      head :created
    else
      error = ErrorSerializer.serialize(@question.errors)
      render json: error, status: :bad_request
    end
  end

  def update
    if @question.update(question_params)
      MediaTagger.call(@question.id, "question", params[:question][:tags]) if params[:question][:tags]
      head :ok
    else
      error = ErrorSerializer.serialize(@question.errors)
      render json: error, status: :bad_request
    end
  end

  def destroy
    if @question.archived!
      head :no_content
    else
      error = ErrorSerializer.serialize(@question.errors)
      render json: error, status: :bad_request
    end
  end

  def like
    if ContentLiker.call(@question, current_user)
      head :ok
    else
      error = ErrorSerializer.serialize({ like: "Question could not be liked." })
      render json: error, status: :bad_request
    end
  end

  def unlike
    if ContentLiker.call(@question, current_user, false)
      head :ok
    else
      error = ErrorSerializer.serialize({ like: "Question could not be unliked." })
      render json: error, status: :bad_request
    end
  end

  def dislike
    if ContentDisliker.call(@question, current_user)
      head :ok
    else
      error = ErrorSerializer.serialize({ dislike: "Question could not be disliked." })
      render json: error, status: :bad_request
    end
  end

  def undislike
    if ContentDisliker.call(@question, current_user, false)
      head :ok
    else
      error = ErrorSerializer.serialize({ dislike: "Question could not be undisliked." })
      render json: error, status: :bad_request
    end
  end

  private

  def question_params
    params.require(:question).permit([:text, :sponsored, :tags])
  end

  def set_question
    @question = Question.find(params[:id])
  end

  def set_questions
    if current_user.is_a? Athlete
      Question.active.includes(:reactions)
    else
      Question.active.includes(:reactions).answered
    end
  end
end
