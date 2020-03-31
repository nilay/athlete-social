class Video < ApplicationRecord
  before_create :set_guid
  belongs_to :post

  def translated_profiles
    return {} unless profiles

    {
      mobile_url: profiles['h264_url'],
      intro_url: profiles['intro_mov_url'],
      share_url: profiles['watermark_export_url']
    }
  end

  private

  def set_guid
    self.guid = SecureRandom.hex(16)
  end
end
