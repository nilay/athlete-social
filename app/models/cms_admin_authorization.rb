class CmsAdminAuthorization < ApplicationRecord
  include Challah::Authorizeable

  def self.user_model
    CmsAdmin
  end
end
