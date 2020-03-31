module Blockable
  extend ActiveSupport::Concern

  def create_block(user)
    Blocking.create(blocker_id: self.id, blocker_type: "#{self.class.to_s.underscore}_blocker".to_sym,
      blocked_user_id: user.id, blocked_user_type: user.class.to_s.underscore.to_sym)
  end

  def blockings
    Blocking.where(blocker_id: id, blocker_type: "#{self.class.to_s.underscore}_blocker".to_sym)
  end

  def blocked_athletes
    blockings.athlete.map(&:blocked_user)
  end

  def blocked_fans
    blockings.fan.map(&:blocked_user)
  end

  def all_blocked
    blockings.map(&:blocked_user)
  end
  
end
