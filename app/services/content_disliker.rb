class ContentDisliker
  attr_reader :content, :unliker, :dislike

  def initialize(content, unliker, dislike = true)
    @content = content
    @unliker = unliker
    @dislike = dislike
  end

  def run
    if dislike == false
      content.undisliked_by unliker
    else
      content.disliked_by unliker
    end
  end

  def self.call(*args)
    new(*args).run
  end
end
