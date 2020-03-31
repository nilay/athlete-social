require "rails_helper"

RSpec.describe "Video Requests", type: :request do

  describe ".notifications" do
    context "video-encoded" do
      it "fires a VideoEncodingCompletionJob" do
        expect(VideoEncodingCompletionJob).to receive(:perform_async).with("OU812")
        post "/api/v1/videos/notifications", params: { event: "video-encoded", video_id: "OU812" }
      end
    end
    context "not video-encoded" do
      it "does not fire a VideoEncodingCompletionJob" do
        expect(VideoEncodingCompletionJob).not_to receive(:perform_async).with("OU812")
        post "/api/v1/videos/notifications", params: { event: "video-failed", video_id: "OU812" }
      end
    end
  end

end
