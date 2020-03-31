require "rails_helper"

RSpec.describe PostRanker, type: :service do
  describe ".call" do
    before(:example) do
      @post = create :post, share_count: 5
    end

    it "ranks the post" do
      expect(@post.rank).to eq 0.0
      @post.created_at = "Wed, 06 Apr 2020 17:05:02 UTC +00:00"
      @post.save
      expect {
        PostRanker.call(@post.id)
      }.to change { @post.reload.rank }
    end
  end
end
