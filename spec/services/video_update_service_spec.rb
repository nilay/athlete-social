require "rails_helper"

RSpec.describe VideoUpdateService, type: :service do
  describe ".call" do
    let!(:post) { create :post }
    let!(:video) { create :video, post: post }

    it "sets urls for video encoding" do
      t_video = double("Telestream Video", id: "OU812", path: "original/#{video.guid}")
      intro_mov = double("intro_mov", profile_name: "intro-mov", url: "http://example-mov.com")
      h_264 = double("h264", profile_name: "h264", url: "http://example.com", screenshots: ["http://www.google.com", "http://www.apple.com"])
      watermark = double("watermark", profile_name: "watermark-export", url: "http://watermark-export.com")

      expect(TelestreamCloud::Video).to receive(:find).with("OU812") { t_video }
      expect(t_video).to receive(:path) { video.guid }
      allow(t_video).to receive(:encodings) { [h_264, watermark, intro_mov] }
      expect(h_264).to receive(:screenshots)
      VideoUpdateService.call("OU812")
      video.reload
      post.reload
      expect(video.profiles["intro_mov_url"]).to eq "http://example-mov.com"
      expect(video.profiles["h264_url"]).to eq "http://example.com"
      expect(video.profiles["watermark_export_url"]).to eq "http://watermark-export.com"
      expect(video.thumbnail_url).to eq "http://www.google.com"
      expect(post.status).to eq "complete"
      expect(post.thumbnail_url).to eq "http://www.google.com"
    end
  end
  describe ".call on an archived post" do
    let!(:post) { create :post, status: "archived" }
    let!(:video) { create :video, post: post }

    it "sets urls for video encoding" do
      t_video = double("Telestream Video", id: "OU812", path: "original/#{video.guid}")
      intro_mov = double("intro_mov", profile_name: "intro-mov", url: "http://example-mov.com")
      h_264 = double("h264", profile_name: "h264", url: "http://example.com", screenshots: ["http://www.google.com", "http://www.apple.com"])
      watermark = double("watermark", profile_name: "watermark-export", url: "http://watermark-export.com")

      expect(TelestreamCloud::Video).to receive(:find).with("OU812") { t_video }
      expect(t_video).to receive(:path) { video.guid }
      allow(t_video).to receive(:encodings) { [h_264, watermark, intro_mov] }
      expect(h_264).to receive(:screenshots)
      VideoUpdateService.call("OU812")
      post.reload
      expect(post.status).to eq "archived"
    end
  end
end
