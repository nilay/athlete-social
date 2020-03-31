class AutoFollowerJob
  include Sidekiq::Worker
  sidekiq_options retry: 2, queue: :high


  def perform(*args)
    AutoFollower.call(*args)
  end
end
