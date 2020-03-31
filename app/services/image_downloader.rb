class ImageDownloader
  attr_reader :guid, :post_id, :image_path

  def initialize(post_id, guid)
    @guid       = guid
    @post_id    = post_id
    @image_path = S3.resource(:images).public_url_for(guid)
  end

  def run
    image = Image.where(guid: guid, post_id: post_id).first_or_create
    process_image(image)
    delete_s3_file
    update_post
  end

  def self.call(*args)
    new(*args).run
  end

  private

  def delete_s3_file
    S3.resource(:images).delete(guid)
  end

  def notify(athlete)
    # We'll send a push notification to the athlete's phone here.
  end

  def process_image(image)
    image.file = URI.parse(image_path)
    image.save!
    image
  end

  def update_post
    Post.find(post_id).complete!
  end
end
