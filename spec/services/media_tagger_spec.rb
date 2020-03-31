require "rails_helper"

RSpec.describe MediaTagger, type: :service do
  describe ".call" do
    before(:example) do
      @beast_mode = create :athlete
      @supercam   = create :athlete
      @post       = create :post, athlete_id: @beast_mode.id
    end

    it "creates a hashtag list" do
      expect(PushNotifierJob).to receive(:perform_async).with([@supercam.to_global_id.to_s],
                                                              "You have been tagged in #{@beast_mode.name}'s post!",
                                                              "pros://posts/#{@post.id}")
      MediaTagger.call(@post.id, "post", ["#awesome", "#gnarly", "#{@supercam.id}"])
      @post.reload
      expect(@post.hashtag_list.include?("#gnarly")).to be true
      expect(@post.hashtag_list.include?("#awesome")).to be true
      expect(@post.athletes_tagged_list).to eq(["#{@supercam.id}"])
    end
  end
end
