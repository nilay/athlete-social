require "rails_helper"

RSpec.describe NewAthleteFollowingJob, type: :job do

  describe "perform" do
    let(:athlete) { create :athlete }
    before do
      @athletes = create_list :athlete, 5
      @fans = create_list :fan, 5
    end
    it "makes athletes and fans follow a new athlete" do
      @athletes.each do |a|
        expect(a.following?(athlete)).to eq(false)
      end
      @fans.each do |a|
        expect(a.following?(athlete)).to eq(false)
      end
      NewAthleteFollowingJob.new.perform(athlete.id)
      athlete.reload
      @athletes.each do |a|
        expect(a.following?(athlete)).to eq(true)
      end
      @fans.each do |a|
        expect(a.following?(athlete)).to eq(true)
      end
    end
  end
end
