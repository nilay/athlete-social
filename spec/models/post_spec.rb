require "rails_helper"

RSpec.describe Post, type: :model do
  it_behaves_like "notifiable"
  
  it { should have_many :reactions }
  it { should belong_to :parent }

  describe "#tagged_athletes" do
    before(:example) do
      @cam     = create :athlete
      @russell = create :athlete
      @post    = create :post, athlete: @cam
      @post.athletes_tagged_list = [@russell.id]
    end

    it "returns any athlete tagged in a post" do
      expect(@post.tagged_athletes).to eq([@russell])
    end
  end

  describe "#owner_name" do
    before(:example) do
      @athlete = create :athlete, first_name: "Cam", last_name: "Newton"
      @post = create :post, athlete: @athlete
    end

    it "returns the owner name of the post" do
      expect(@post.owner_name).to eq "Cam Newton"
    end
  end

end
