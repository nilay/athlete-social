module Notifiable
  extend ActiveSupport::Concern

  def add_text(user = nil)
    "#{user.name} just added a new #{self.class.to_s.downcase}!"
  end

  def comment_left_text(user)
    "#{user.name} commented on your #{self.class.to_s.downcase}."
  end

  def deep_link
    "#{ENV["DEEP_LINK"]}://#{self.class.to_s.downcase.pluralize}/#{id}"
  end

  def personal_response_text(user = nil)
    "#{user.name} responded to your #{self.class.to_s.downcase}."
  end

  def response_text(user = nil)
    push_response(user)
  end
end
