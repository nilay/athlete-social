require 'rails_helper'

RSpec.describe Video, type: :model do
  describe "#translated_profiles" do
    before(:example) do
      @video = create :video
    end

    it "returns an empty hash if profiles is nil" do
      expect(@video.translated_profiles).to eq({})
    end

    it "returns a filled hash if profiles is present" do
      @video.profiles = { h264_url: '', intro_mov_url: '' }
      expect(@video.translated_profiles.keys.present?).to be true
    end
  end
end
