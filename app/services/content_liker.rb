class ContentLiker
  attr_reader :content, :liker, :like

  def initialize(content, liker, like = true)
    @content = content
    @liker   = liker
    @like    = like
  end

  def run
    if like == false
      content.unliked_by liker
    else
      content.liked_by liker
    end
  end

  def self.call(*args)
    new(*args).run
  end
end
