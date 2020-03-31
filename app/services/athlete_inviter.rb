class AthleteInviter
  attr_reader :inviter, :email, :name, :phone

  def initialize(inviter, params)
    @inviter = inviter
    @email   = params[:email]
    @name    = params[:name]
    @phone   = params[:phone_number]
  end

  def run
    invitation = inviter.create_invitation(email: email, name: name, phone: phone)
    if invitation.valid?
      notify_invitee!(invitation)
    end
    invitation
  rescue => e
    ReportError.call(exception: e)
  end

  def self.call(*args)
    new(*args).run
  end

  private

  def notify_invitee!(invitation)
    if invitation.email
      InvitationMailer.invite_email(invitation).deliver
    else
      SmsSenderJob.perform_async(phone, sms_message(invitation))
    end
  end

  def sms_message(invite)
    "Hi #{name}, #{inviter.name} has invited you to be a part of the Pros App.  Click below to join the team. #{ENV["DOMAIN"]}/invite/#{invite.invite_token}"
  end
end
