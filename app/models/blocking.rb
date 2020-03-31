class Blocking < ApplicationRecord
  enum blocked_user_type: { athlete: 0, fan: 1 }
  enum blocker_type: { athlete_blocker: 0, fan_blocker: 1}

  def blocked_user
    blocked_user_type.classify.constantize.where(id: blocked_user_id).first
  end

  def blocker
    blocker_type.gsub("_blocker",'').classify.constantize.where(id: blocker_id).first
  end

end
