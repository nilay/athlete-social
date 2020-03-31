class Api::V1::ReactionsController < Api::V1::ApplicationController

  def show
    if params[:post_id]
      @post = Post.find(params[:post_id])
    elsif params[:question_id]
      @question = Question.find(params[:question_id])
    end
    @reaction = Post.find(params[:id])
    render :show, status: :ok
  end
end
