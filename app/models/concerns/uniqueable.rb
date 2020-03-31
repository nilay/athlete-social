module Uniqueable
  extend ActiveSupport::Concern
  UNIQUEABLE_CLASSES = %w[ CmsAdmin Fan Athlete BrandUser ]

  included do
    unless UNIQUEABLE_CLASSES.include?(self.to_s)
      raise "must add uniqueable class to ensure unique usernames"
    end
    validate :unique_username
  end

  def unique_username
    result = UNIQUEABLE_CLASSES.any? do |c|
      user = c.constantize.find_by_email(email)
      user && user != self
    end
    errors.add(:email, "can't belong to another user") if result == true
  end
end
