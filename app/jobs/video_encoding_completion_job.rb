class VideoEncodingCompletionJob
  include Sidekiq::Worker
  sidekiq_options retry: 2, queue: :high

  def perform(*args)
    VideoUpdateService.call(*args)
  end
end
