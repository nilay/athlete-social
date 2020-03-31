class Image < ApplicationRecord
  has_attached_file :file,
    styles: { thumb: "200x200>",
              medium: "640x640>",
              large: "1080x1080>",
              x_large: "1242x1242>" },
    default_url: "/images/:style/missing.jpg",
    path: "images/:instance_guid/:style/:filename"

  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/
  belongs_to :post

  def self.upload_url(id)
    S3.resource(:images).upload_url_for(id, "image/jpg")
  end

end
