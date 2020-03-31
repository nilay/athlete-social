require "rails_helper"

RSpec.describe VideoUpdateService, type: :service do
  describe ".call" do
    before(:example) do
    @post = create :post
    @video = create :video
    @video_hash = {
                    video_guid: "original\/#{@video.guid}",
                    panda_video_id: "afd3217b36e557d49a9ae2ea6e390f2c"
                  }
    end

    it "associates posts to videos" do
      VideoPostAssociator.call(@post.id, @video_hash)
      @video.reload
      expect(@video.panda_video_id).to eq("afd3217b36e557d49a9ae2ea6e390f2c")
      expect(@video.post_id).to eq(@post.id)
    end
  end
end
