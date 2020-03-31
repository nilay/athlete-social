class PostsController < ApplicationController
  def show
    @post = Post.where(id: params[:id]).includes(:reactions).first

    if @post&.parent_id && !@post.question?
      @post   = @post.parent
      @anchor = params[:id]
    end

  end
end
