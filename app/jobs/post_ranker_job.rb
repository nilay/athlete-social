class PostRankerJob
  include Sidekiq::Worker
  sidekiq_options retry: 2, queue: :ranking

  def perform(*args)
    PostRanker.call(*args)
  end
end
