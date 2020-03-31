class Admin::QuestionsController < Admin::ApplicationController
  load_and_authorize_resource
  before_action :set_question, only: [:update, :activate, :deactivate, :archive, :destroy, :show]

  def index
    @questions = Question.all
      .order('created_at DESC')
      .page(params[:page])
      .per(25)

    respond_to do |format|
      format.html
      format.json
    end
  end

  def active
    @questions = Question.active
      .order('created_at DESC')
      .page(params[:page])
      .per(25)

    respond_to do |format|
      format.html
      format.json
    end
  end

  def inactive
    @questions = Question.inactive
      .order('created_at DESC')
      .page(params[:page])
      .per(25)

    respond_to do |format|
      format.html
      format.json
    end
  end

  def show
  end

  def create
    @question = Question.new(question_params)

    if @question.save
      MediaTagger.call(@question.id, "question", params[:question][:tags]) if params[:question][:tags]
      render :show, status: :created
    else
      error = ErrorSerializer.serialize(@question.errors)
      render json: error, status: :bad_request
    end
  end

  def update
    if @question.update_attributes(question_params)
      render :show, status: :ok
    else
      error = ErrorSerializer.serialize(@question.errors)
      render json: error, status: :bad_request
    end
  end

  def archive
    if @question.update_attributes(status: params[:status])
      render :show, status: :ok
    else
      error = ErrorSerializer.serialize(@question.errors)
      render json: error, status: :bad_request
    end
  end

  def activate
    if @question.active!
      render :show, status: :ok
    else
      error = ErrorSerializer.serialize(@question.errors)
      render json: error, status: :bad_request
    end
  end

  def deactivate
    if @question.inactive!
      render :show, status: :ok
    else
      error = ErrorSerializer.serialize(@question.errors)
      render json: error, status: :bad_request
    end
  end

  def destroy
    if @question.destroy
      head :no_content
    else
      error = ErrorSerializer.serialize(@question.errors)
      render json: error, status: :bad_request
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit([:text, :sponsored, :questioner_id, :questioner_type, :status, :tags])
  end

end
