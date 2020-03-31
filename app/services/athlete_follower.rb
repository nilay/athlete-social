class AthleteFollower
  attr_reader :athlete, :follower

  def initialize(athlete, follower)
    @athlete = athlete
    @follower = follower
  end

  def run
    unless follower.following?(athlete)
      following = follower.follow(athlete)
      if follower.is_a? Athlete
        PushNotifierJob.perform_async(athlete.to_global_id.to_s, "#{follower.name} just followed you.")
      end
      following
    end
  end

  def self.call(*args)
    new(*args).run
  end
end
