class NotificationMailer < ActionMailer::Base
  default from: "Mycelial <damian@mycelial.com>"

  def send_like_notification(like, user_email)
    @like = like
    mail to: user_email, subject: "#{like.username} just liked your project on Mycelial"
  end

  def send_comment_notification(comment, user_email)
    @comment = comment
    mail to: user_email, subject: "#{comment.username} just commented on your project"
  end
end
