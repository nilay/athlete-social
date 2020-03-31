class Api::V1::PostsController < Api::V1::ApplicationController
  load_and_authorize_resource except: :index
  before_action :set_post, only: [:update, :destroy, :like, :dislike, :show, :shared_video, :flag]
  # GET /posts.json
  def index
    athlete_ids = current_user.following_by_type("Athlete").available_for_api.visible.pluck(:id)
    athlete_ids << current_user.id if current_user.class == Athlete
    @posts = Post.where(athlete_id: athlete_ids)
      .includes(:reactions)
      .complete
      .original
      .order('created_at DESC')
      .page(params[:page])
      .per(25)
  end

  def top
    @posts = Post
      .includes(:reactions)
      .complete
      .original
      .hot
      .page(params[:page])
      .per(25)
  end

  def by_athlete
    @posts = Post.where(athlete_id: params[:athlete_id])
      .complete
      .original
      .order('created_at DESC')
      .page(params[:page])
      .per(25)

    render :index
  end

  def show
  end

  def create
    @post = current_user.posts.new(post_params)
    if @post.save
      post_process(@post)
      render :show, status: :created
    else
      error = ErrorSerializer.serialize(@post.errors)
      render json: error, status: :bad_request
    end
  end

  def update
    if @post.update(post_params)
      VideoPostAssociator.call(@post.id, video_params) unless video_params.blank?
      MediaTagger.call(@post.id, "post", params[:post][:tags]) if params[:post][:tags]
      ImageDownloadJob.perform_async(params[:guid], @post.id, params[:download_url]) if params[:download_url]
      head :ok
    else
      error = ErrorSerializer.serialize(@post.errors)
      render json: error, status: :bad_request
    end
  end

  def shared_video
    if @post.update_shares!
      head :ok
    else
      error = ErrorSerializer.serialize(@post.errors)
      render json: error, status: :bad_request
    end
  end

  def destroy
    if @post.archived!
      head :no_content
    else
      error = ErrorSerializer.serialize(@post.errors)
      render json: error, status: :bad_request
    end
  end

  def like
    if ContentLiker.call(@post, current_user)
      head :ok
    else
      error = ErrorSerializer.serialize({ like: "Post could not be liked." })
      render json: error, status: :bad_request
    end
  end

  def unlike
    if ContentLiker.call(@post, current_user, false)
      head :ok
    else
      error = ErrorSerializer.serialize({ like: "Post could not be unliked." })
      render json: error, status: :bad_request
    end
  end

  def dislike
    if ContentDisliker.call(@post, current_user)
      head :ok
    else
      error = ErrorSerializer.serialize({ dislike: "Post could not be disliked." })
      render json: error, status: :bad_request
    end
  end

  def undislike
    if ContentDisliker.call(@post, current_user, false)
      head :ok
    else
      error = ErrorSerializer.serialize({ dislike: "Post could not be undisliked." })
      render json: error, status: :bad_request
    end
  end

  def flag
    if FlagContentJob.perform_async(@post.id, current_user.id, current_user.class.to_s)
      head :ok
    else
      error = ErrorSerializer.serialize({ flag: "Post could not be flagged as inappropriate."})
      render json: error, status: :bad_request
    end
  end

  def image_upload_url
    @image_guid = SecureRandom.hex(16)
  end

  private

  def notify_of_reaction(post)
    parent = post.parent_object
    PushNotifierJob.perform_async([parent.athlete.to_global_id.to_s],
                                  parent.personal_response_text(post.athlete),
                                  parent.deep_link)
  end

  def post_params
    params.require(:post).permit([:content_type, :parent_id, :parent_type])
  end

  def post_process(post)
    VideoPostAssociator.call(post.id, video_params) unless video_params.blank?
    MediaTagger.call(post.id, "post", params[:post][:tags]) if params[:post][:tags]
    ImageDownloadJob.perform_async(post.id, params[:post][:image_guid]) unless image_params.blank?
    if post.parent_id
      PushNotifierJob.perform_async(current_user.follower_global_ids - [post.parent_athlete.to_global_id.to_s],
                                    post.parent_object.response_text(current_user),
                                    post.parent_object.deep_link)
    else
      PushNotifierJob.perform_async(current_user.follower_global_ids,
                                    post.add_text(current_user),
                                    post.deep_link)
    end
    notify_of_reaction(post) if post.parent_id
  end

  def video_params
    params.require(:post).permit([:video_guid, :panda_video_id])
  end

  def image_params
    params.require(:post).permit([:image_guid, :download_url])
  end

  def set_post
    @post = Post.find(params[:id])
  end
end
