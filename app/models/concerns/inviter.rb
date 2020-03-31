module Inviter
  extend ActiveSupport::Concern

  def create_invitation(invite_hash)
    Invitation.create(inviter_id: id,
                   inviter_type: self.class.to_s.underscore.to_sym,
                   email: invite_hash[:email],
                   invitee_name: invite_hash[:name],
                   phone_number: invite_hash[:phone],
                   expires_on: Time.now+2.days)
  end

  def sent_invitations
    Invitation.where(inviter_id: id, inviter_type: self.class.to_s.underscore.to_sym)
  end

  def invitees
    sent_invitations.map(&:invitee).compact
  end

end
