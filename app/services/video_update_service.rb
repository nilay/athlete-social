class VideoUpdateService
  attr_reader :panda_video, :video

  VIDEO_URL_HASH = { "hls.recommended.manifest" => :hls_recommended_manifest_url,
                     "h264" => :h264_url,
                     "watermark-export" => :watermark_export_url,
                     "intro-gif" => :intro_gif_url,
                     "intro-mov" => :intro_mov_url
                   }

  def initialize(panda_video_id)
    @panda_video = TelestreamCloud::Video.find(panda_video_id)
    video_guid = panda_video.path.split('/')[-1]
    @video       = Video.where(guid: video_guid).last
  end

  def run
    profiles = create_video_url_json
    update_video_profiles(profiles)
    update_video_post if video.post.pending?
  end

  def self.call(*args)
    new(*args).run
  end

  private

  def create_video_url_json
    profiles = {}
    panda_video.encodings.map { |e| profiles[VIDEO_URL_HASH[e.profile_name]] = e.url.to_s }
    profiles.delete_if{ |k, v| k.blank? || v.blank? }
  end

  def thumbnail_location
    @thumbnail_location ||= panda_video.encodings.select{|e| e.profile_name == "h264"}.first.screenshots.first
  end

  def update_video_post
    video.post.content_type = "video"
    video.post.thumbnail_url = thumbnail_location
    video.post.complete!
  end

  def update_video_profiles(profiles)
    video.profiles = profiles
    video.panda_video_id = panda_video.id
    video.thumbnail_url = thumbnail_location
    video.save!
  end
end
