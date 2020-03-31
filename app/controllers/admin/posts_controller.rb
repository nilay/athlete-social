class Admin::PostsController < Admin::ApplicationController
  load_and_authorize_resource
  before_action :set_post

  def destroy
    if @post.archived!
      head :no_content
    else
      error = ErrorSerializer.serialize(@post.errors)
      render json: error, status: :bad_request
    end
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
