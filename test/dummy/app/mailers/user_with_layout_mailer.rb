class UserWithLayoutMailer < ApplicationMailer
  layout "mail_layout"

  def welcome
    mail(
      to: "foo@example.com",
      reply_to: "noreply@schneems.com",
      subject: "hello world"
    )
  end
end
