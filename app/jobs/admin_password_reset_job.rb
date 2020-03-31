class AdminPasswordResetJob
  include Sidekiq::Worker
  sidekiq_options retry: 2, queue: :mailers

  def perform(*args)
    ::NotificationsMailer.admin_password_reset(*args).deliver_now
  end

end
