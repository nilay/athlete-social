class PostFlagger
  attr_accessor :post_id, :flagger_id, :flagger_type

  def initialize(post_id, flagger_id, flagger_type)
    @post_id = post_id
    @flagger_id = flagger_id
    @flagger_type = flagger_type
  end

  def run
    flag_and_notify!
  end

  def self.call(*args)
    new(*args).run
  end

  private

  def create_flagging_record
    Flagging.create(flagger_id: flagger.id, flagger_type: flagger.class.to_s.underscore.to_sym, post_id: post.id)
  end

  def flag_and_notify!
    create_flagging_record
    FlaggedContentMailer.flagged_content(post_id).deliver
  end

  def flagger
    flagger_type.classify.constantize.where(id: flagger_id).first
  end

  def post
    @post ||= Post.find(post_id)
  end
end
