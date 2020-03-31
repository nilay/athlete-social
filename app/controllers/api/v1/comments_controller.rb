class Api::V1::CommentsController < Api::V1::ApplicationController
  load_and_authorize_resource


  def create
    @comment = Comment.new(comment_params)
    @comment.athlete = current_user

    if @comment.save
      @post = @comment.commentable
      unless @post.athlete == @comment.athlete
        PushNotifierJob.perform_in(1.minutes, [@post.athlete.to_global_id.to_s],
                                   @post.comment_left_text(@comment.athlete),
                                   @post.deep_link, "named_user", ["ios"], @comment.to_global_id.to_s)
      end
      render status: :created
    else
      error = ErrorSerializer.serialize(@comment.errors)
      render json: error, status: :bad_request
    end
  end

  def destroy
    @comment = current_user.comments.find(params[:id])
    if @comment.destroy
      head :no_content
    else
      error = ErrorSerializer.serialize(@comment.errors)
      render json: error, status: :bad_request
    end
  end


  private

  def comment_params
    # TODO: Make commentable_type a whitelist to prevent creation of comments for
    # unsupported models.
    params.require(:comment).permit([:commentable_type, :commentable_id, :text])
  end
end
