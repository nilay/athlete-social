class ImageDownloadJob
  include Sidekiq::Worker
  sidekiq_options retry: 2, queue: :high

  def perform(*args)
    ImageDownloader.call(*args)
  end

  sidekiq_retries_exhausted do |msg|
    CleanUpImageDownloadFailureJob.perform_async(msg["args"])
  end

end
