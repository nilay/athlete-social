class FlaggedContentMailer < ApplicationMailer
  def flagged_content(post_id)
    @post   = Post.find(post_id)
    @emails = CmsAdmin.email_opted.map(&:email)
    @mail   = mail(
      to: @emails,
      subject: "Content has been flagged as inappropriate!"
    )
  end
end
