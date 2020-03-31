class NewAthleteFollowingJob
  include Sidekiq::Worker
  sidekiq_options retry: 2, queue: :high


  def perform(id)
    athlete = Athlete.find(id)
    Fan.all.map{ |f| AthleteFollower.call(athlete, f) }
    Athlete.all.map{ |a| AthleteFollower.call(athlete, a) }
  end
end
