class NotificationsMailer < ApplicationMailer
  def password_reset(id, klass, new_password)
    @password = new_password
    @user = klass.constantize.find(id)
    @mail = mail(
      to: @user.email,
      subject: "Password Reset for Pros"
    )
  end

  def admin_password_reset(id, token)
    @password_reset = PasswordReset.find(token)
    @user = CmsAdmin.find(id)

    mail(to: @user.email, subject: "Reset Your Pros Admin Password")
  end
end
