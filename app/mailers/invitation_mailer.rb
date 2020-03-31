class InvitationMailer < ApplicationMailer
  def invite_email(invitation)
    @invitation = invitation
    @inviter    = @invitation.inviter
    @mail = mail(
      to: @invitation.email,
      subject: "#{@inviter.name} wants you to join Pros!"
    )
  end
end
