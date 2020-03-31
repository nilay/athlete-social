class Avatar < ApplicationRecord
  enum avatar_owner_type: { athlete: 0, fan: 1, cms_admin: 2, brand_user: 3, brand: 4 }
  has_attached_file :file,
    styles: {
      medium: "300x300>",
      thumb: "150x150>"
    },
    default_url: "http://#{ENV["AWS_S3_BUCKET"]}.s3.amazonaws.com/#{Rails.env}/images/default_avatar/avatar_:style.png",
    path: ":owner_class/:owner_id/avatars/:style/:filename"

  validates_attachment_content_type :file, content_type: /\Aimage\/.*\Z/

  def self.upload_url(id)
    S3.resource(:avatars).upload_url_for(id, "image/jpg")
  end

  def owner
    avatar_owner_type.camelize.constantize.find(avatar_owner_id)
  end
end
