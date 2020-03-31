class AutoFollower
  attr_reader :athlete_ids, :user_id, :user_klass

  def initialize(user_id, klass, athlete_ids = nil)
    @athlete_ids  = athlete_ids
    @user_id      = user_id
    @user_klass   = klass.to_s
  end

  def run
    follow_all_athletes!
  end

  def self.call(*args)
    new(*args).run
  end

  private

  def athletes
    @athletes ||= if athlete_ids
      Athlete.find(athlete_ids)
    else
      emails = YAML.load_file('lib/athletes.yml').values.map{ |v| v["email"].downcase }
      Athlete.where(email: emails)
    end
  end

  # TODO: modify this and the athletefollower to accept one or all the athlete id's at once,
  # and spare all the individual calls and separate database inserts
  def follow_all_athletes!
    athletes.map { |a| AthleteFollower.call(a, follower) }
  end

  def follower
    @user ||= user_klass.constantize.find(user_id)
  end
end
