module Avatarable
  extend ActiveSupport::Concern
  included do
    after_create :create_blank_avatar
  end

  def avatar
    Avatar.where(avatar_owner_id: id, avatar_owner_type: self.class.to_s.underscore.to_sym).first
  end

  def build_avatar(upload_url)
    Avatar.new(avatar_owner_id: id,
               avatar_owner_type: self.class.to_s.underscore.to_sym,
               direct_upload_url: upload_url)
  end

  def avatar_url(style = :original, api = true)
    if avatar.file_file_name || api == false
      avatar.file.url(style)
    else
      nil
    end
  end

  private

  def create_blank_avatar
    Avatar.new(avatar_owner_id: id, avatar_owner_type: self.class.to_s.underscore.to_sym).save
  end
end
