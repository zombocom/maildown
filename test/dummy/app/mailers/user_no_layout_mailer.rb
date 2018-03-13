class UserNoLayoutMailer < ApplicationMailer
  layout false

  def leading_whitespace
    mail(
      to:       "foo@example.com",
      reply_to: "noreply@schneems.com",
      subject:  "hello world"
    )
  end

  def welcome
    mail(
      to:       "foo@example.com",
      reply_to: "noreply@schneems.com",
      subject:  "hello world"
    )
  end
end
