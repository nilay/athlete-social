require "rails_helper"

RSpec.describe UserBlocker, type: :service do
  describe ".call" do
    before(:example) do
      @athlete = create :athlete
      @other   = create :athlete
      @fan     = create :fan
    end

    it "blocks an athlete from following another athlete" do
      UserBlocker.call(@athlete.id, @athlete.class.to_s, @other.id, @other.class.to_s)
      expect(@athlete.blocked_athletes.include?(@other)).to be true
    end

    it "blocks a fan from following another athlete" do
      UserBlocker.call(@athlete.id, @athlete.class.to_s, @fan.id, @fan.class.to_s)
      expect(@athlete.blocked_fans.include?(@fan)).to be true
    end

  end
end
