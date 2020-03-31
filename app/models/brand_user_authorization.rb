class BrandUserAuthorization < ApplicationRecord
  include Challah::Authorizeable

  def self.user_model
    BrandUser
  end
end
