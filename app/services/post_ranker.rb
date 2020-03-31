class PostRanker
  attr_accessor :post_id

  def initialize(post_id)
    @post_id = post_id
  end

  def run
    rank!
  end

  def self.call(*args)
    new(*args).run
  end

  private

  # Stolen from reddit's algorithm (and adapted)
  def rank!
    post = Post.find_by(id: post_id)

    if post
      # Add up the counts
      # (share count weighted highest, then reactions, comments and likes get the least value)
      sum = post.share_count*5 + post.reactions.count*2 + post.comments.count + post.get_likes.size.to_f/5
      # Normalize it using logarithmic math
      order = Math::log(sum, 10)
      # Fetch seconds since pro's first post submission
      seconds = post.created_at.to_f - 1459190610
      # Rank it so that newer posts are valued higher over time
      rank = (order + seconds / 45000).round(7)
      # Update post
      post.update_attributes(rank: rank)
    end
  end
end
