class Invitation < ApplicationRecord
  enum inviter_type: { athlete: 0, cms_admin: 1 }

  before_create :create_invite_token


  validate :athlete_does_not_exist, on: :create
  validate :no_invitations_pending, on: :create
  validates :phone_number, format: { with: /\d{10}/, message: "phone number must be area code and phone number." }, if: :phone_number_present?
  validates :email, format: { with: /\A(\S+)@(.+)\.(\S+)\z/, message: "email must be in valid format." }, if: :email_present?
  def invalid?
    expires_on && expires_on <= Time.now
  end

  def inviter
    self.inviter_type.classify.constantize.find(inviter_id)
  end

  def invitee
    Athlete.where(id: self.invitee_id).first
  end

  def invitee=(athlete)
    self.invitee_id = athlete.id
  end

  private

  def athlete_does_not_exist
    unless Athlete.find_by_email(self.email).nil?
      errors.add(:athlete, "#{self.email} has already joined Pros.")
    end
  end

  def create_invite_token
    self.invite_token = SecureRandom.hex(6)
  end

  def email_present?
    email.present?
  end

  def no_invitations_pending
    if self.email?
      invitations = Invitation.where(invitee_id: nil, email: self.email, created_at: (Time.current-2.days..Time.current))
    else
      invitations = Invitation.where(invitee_id: nil, phone_number: self.phone_number, created_at: (Time.current-2.days..Time.current))
    end
    errors.add(:pending_invite, "This Athlete has a pending invitation to join Pros") unless invitations.blank?
  end

  def phone_number_present?
    phone_number.present?
  end

end
