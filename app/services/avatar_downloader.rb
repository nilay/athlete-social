class AvatarDownloader
  attr_reader :avatar_id, :guid, :image_path

  def initialize(avatar_id, guid = nil, image_path = nil)
    @avatar_id = avatar_id
    @guid = guid
    @image_path = image_path || S3.resource(:avatars).public_url_for(guid)
  end

  def run
    avatar = Avatar.find(avatar_id)
    avatar.file = URI.parse(image_path)
    avatar.is_uploaded = true
    avatar.save!
  end

  def self.call(*args)
    new(*args).run
  end
end
