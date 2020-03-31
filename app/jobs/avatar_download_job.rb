class AvatarDownloadJob
  include Sidekiq::Worker
  sidekiq_options queue: :high

  def perform(*args)
    AvatarDownloader.call(*args)
  end
end
