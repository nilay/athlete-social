class AthleteUnfollower
  attr_reader :athlete, :unfollower

  def initialize(athlete, unfollower)
    @athlete    = athlete
    @unfollower = unfollower
  end

  def run
    unfollower.stop_following(athlete)
  end

  def self.call(*args)
    new(*args).run
  end
end
