class SmsSenderJob
  include Sidekiq::Worker
  sidekiq_options retry: 2, queue: :push_notifications

  def perform(*args)
    SmsNotifier.call(*args)
  end
end
