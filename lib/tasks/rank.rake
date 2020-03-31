namespace :rank do
  desc "Loops through all complete posts and kicks off jobs to rank them"
  task posts: :environment do
    Post.complete.original.select(:id).find_each do |post|
      PostRankerJob.perform_async(post.id)
    end
  end
end
