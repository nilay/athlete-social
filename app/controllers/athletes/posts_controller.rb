class Athletes::PostsController < Athletes::ApplicationController
  load_and_authorize_resource
  before_action :set_post

  def destroy
    if @post.destroy
      head :no_content
    else
      error = ErrorSerializer.serialize(@post.errors)
      render json: error, status: :bad_request
    end
  end

  def set_post
    @post = current_user.posts.find(params[:id])
  end
end
