module Personable
  extend ActiveSupport::Concern

  included do
    enum account_status: { enabled: 0, disabled: 1 }

    def self.available_for_api
      active.enabled
    end

    before_save :reset_api_key, if: :password_changed?
  end

  def name
    [first_name, last_name.presence].compact.join(" ")
  end

  def deliver_password_reset_instructions!
    password = generate_password
    self.update!(password: password, password_confirmation: password)
    ::PasswordResetJob.perform_async(self.id, self.class.to_s, password)
  end

  def generate_password
    Faker::Team.state.downcase.gsub(' ', '') + Random.rand(99).to_s + Faker::Team.creature
  end


  def need_navbar?
    self.class == CmsAdmin || self.class == BrandUser
  end

  def reset_api_key
    self.api_key = nil
    ensure_api_key_presence
  end

end
