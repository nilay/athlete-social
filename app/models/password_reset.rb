class PasswordReset
  include ActiveModel::Model

  attr_accessor :email, :user_gid, :token

  alias_method :id, :token
  alias_method :to_param, :token

  def clear!
    REDIS.del(redis_key)
  end

  def email
    user&.email
  end

  def persisted?
    token.present? && REDIS.get(redis_key) == user_gid
  end

  def save
    if user_gid.present?
      self.token ||= SecureRandom.urlsafe_base64(128)

      REDIS.set(redis_key, user_gid)
      REDIS.expire(redis_key, 3600)

      true
    else
      false
    end
  end

  def user
    @user ||= GlobalID::Locator.locate(user_gid)
  rescue AciveRecord::RecordNotFound
    nil
  end

  def user=(user)
    self.user_gid = user.to_global_id.to_s
    @user = user
  end

  def self.find(token)
    new(user_gid: REDIS.get("password_resets:#{token}"), token: token)
  end

  private

  def redis_key
    "password_resets:#{token}"
  end
end
