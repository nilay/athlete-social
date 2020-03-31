class CleanUpImageDownloadFailureJob
  include Sidekiq::Worker

  def perform(args)
    image = Image.find_by_guid(args[1])
    image.destroy if image
    post = Post.find(args[0])
    athlete = post.athlete
    post.destroy if post
    PushNotifierJob.perform_async(athlete.to_global_id.to_s, "Your previous post failed to save.")
  end

end
