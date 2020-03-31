class CmsAdmin < ApplicationRecord
  include Challah::Userable
  include Avatarable
  include Uniqueable
  include Personable
  include Questioner
  include Inviter

  attr_accessor :remember_me

  has_many :questions, as: :questionable

  def deliver_password_reset_instructions!(password_reset)
    AdminPasswordResetJob.perform_async(self.id, password_reset.token)
  end

  def self.authorization_model
    CmsAdminAuthorization
  end

  def self.email_opted
    where(opt_in_to_emails: true)
  end
end
