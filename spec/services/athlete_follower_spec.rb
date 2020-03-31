require "rails_helper"

RSpec.describe AthleteFollower, type: :service do
  describe ".call" do
    before(:example) do
      @athlete = create :athlete
      @athlete2 = create :athlete
      @fan     = create :fan
    end

    it "makes fan follow the athlete" do
      AthleteFollower.call(@athlete, @fan)
      @fan.reload
      expect(@fan.following?(@athlete)).to eq(true)
    end

    it "doesn't double follow an athlete" do
      @fan.follow(@athlete)
      expect(PushNotifierJob).not_to receive(:perform_async).with(@athlete.to_global_id.to_s, "#{@fan.name} just followed you.")
      AthleteFollower.call(@athlete, @fan)
      @fan.reload
      expect(@fan.follows.count).to eq(1)
    end

    it "doesn't send the notification for a fan following an athlete" do
      expect(PushNotifierJob).not_to receive(:perform_async).with(@athlete.to_global_id.to_s, "#{@fan.name} just followed you.")
      AthleteFollower.call(@athlete, @fan)
      @fan.reload
      expect(@fan.follows.count).to eq(1)
    end

    it "sends the notification for an athlete following an athlete" do
      expect(PushNotifierJob).to receive(:perform_async).with(@athlete.to_global_id.to_s, "#{@athlete2.name} just followed you.")
      AthleteFollower.call(@athlete, @athlete2)
      @athlete2.reload
      expect(@athlete2.follows.count).to eq(1)
    end

  end
end
