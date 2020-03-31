class FlagContentJob
  include Sidekiq::Worker

  def perform(*args)
    PostFlagger.call(*args)
  end
end
