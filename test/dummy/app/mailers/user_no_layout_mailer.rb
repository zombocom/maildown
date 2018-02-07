class UserNoLayoutMailer < ApplicationMailer
  layout false

  def welcome
    mail(
      to:       "foo@example.com",
      reply_to: "noreply@schneems.com",
      subject:  "hello world"
    )
  end
end
