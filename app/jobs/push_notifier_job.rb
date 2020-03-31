class PushNotifierJob
  include Sidekiq::Worker
  sidekiq_options retry: 2, queue: :push_notifications

  def perform(*args)
    PushNotifier.call(*args)
  end
end
