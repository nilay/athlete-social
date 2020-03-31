class UserBlocker
  attr_accessor :blocker_id, :blocker_type, :blocked_user_id, :blocked_user_type

  def initialize(blocker_id, blocker_type, blocked_user_id, blocked_user_type)
    @blocker_id        = blocker_id
    @blocker_type      = blocker_type
    @blocked_user_id   = blocked_user_id
    @blocked_user_type = blocked_user_type
  end

  def blockee_eligible?
    (blocker != blockee) && no_existing_blocks_between_users?
  end

  def run
    block_user!
  end

  def self.call(*args)
    new(*args).run
  end

  def self.will_allow_block?(*args)
    new(*args).blockee_eligible?
  end

  private

  def block_user!
    blocking = blocker.create_block(blockee)
    ::BlockedUserMailer.notify_user(blocking.id).deliver
  end

  def blockee
    @blockee ||= blocked_user_type.classify.constantize.where(id: blocked_user_id).first
  end



  def blocker
    @blocker ||= blocker_type.classify.constantize.where(id: blocker_id).first
  end

  def enum_blocker_type
    Blocking.blocker_types["#{blocker_type}_blocker".downcase.to_sym]
  end

  def enum_blocked_user_type
    Blocking.blocked_user_types[blocked_user_type.downcase.to_sym]
  end

  def no_existing_blocks_between_users?
    blocks = Blocking.where(blocker_id: blocker_id, blocker_type: enum_blocker_type, blocked_user_type: enum_blocked_user_type, blocked_user_id: blocked_user_id)
    if blocks.empty?
      return true
    else
      return false
    end
  end
end
