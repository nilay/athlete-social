class VideoPostAssociator
  attr_reader :post_id, :video_guid, :panda_video_id

  def initialize(post_id, video_hash)
    @post_id = post_id
    @video_guid = video_hash[:video_guid].split('/')[-1]
    @panda_video_id = video_hash[:panda_video_id]
  end

  def run
    video = Video.find_by_guid(video_guid)
    video.panda_video_id = panda_video_id
    post = Post.find(post_id)
    post.video = video
  end

  def self.call(*args)
    new(*args).run
  end
end
