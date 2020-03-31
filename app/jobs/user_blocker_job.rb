class UserBlockerJob
  include Sidekiq::Worker
  
  def perform(*args)
    UserBlocker.call(*args)
  end

end
