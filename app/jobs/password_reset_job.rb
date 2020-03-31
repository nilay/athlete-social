class PasswordResetJob
  include Sidekiq::Worker
  sidekiq_options retry: 2, queue: :mailers

  def perform(*args)
    ::NotificationsMailer.password_reset(*args).deliver_now
  end

end
