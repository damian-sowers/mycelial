class Welcome < ActionMailer::Base
  default from: "damian@mycelial.com"

  def send_welcome_email(user_email)
  	mail to: user_email, subject: "Damian from Mycelial. Thanks for trying it out!"
  end
end
