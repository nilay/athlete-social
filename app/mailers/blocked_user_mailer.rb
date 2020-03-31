class BlockedUserMailer < ApplicationMailer
  def notify_user(blocking_id)
    @blocking   = Blocking.find(blocking_id)
    @blocker    = @blocking.blocker
    @mail       = mail(
      to: @blocker.email,
      subject: "You've just blocked #{@blocking.blocked_user.name}"
    )
  end
end
