class FanAuthorization < ApplicationRecord
  include Challah::Authorizeable

  def self.user_model
    Fan
  end
end
