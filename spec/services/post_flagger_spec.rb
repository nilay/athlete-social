require "rails_helper"

RSpec.describe PostFlagger, type: :service do
  describe ".call" do
    before(:example) do
      @admin      = create :cms_admin
      @offended   = create :athlete
      @beast_mode = create :athlete
      @post       = create :post, athlete_id: @beast_mode.id, status: :complete
    end

    it "flags content as inappropriate" do
      mailer = double("mailer")
      expect(FlaggedContentMailer).to receive(:flagged_content).with(@post.id).and_return(mailer)
      expect(mailer).to receive(:deliver)
      PostFlagger.call(@post.id, @offended.id, @offended.class.to_s)
      @post.reload
      expect(@post.status).to eq("complete")
      expect(@post.flaggings.count).to eq 1
    end
  end
end
