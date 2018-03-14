class UserNoLayoutMailer < ApplicationMailer
  layout false

  def welcome
    mail(
      to:       "foo@example.com",
      reply_to: "noreply@schneems.com",
      subject:  "hello world"
    )
  end

  def leading_whitespace
    mail(
      to:       "foo@example.com",
      reply_to: "noreply@schneems.com",
      subject:  "hello world"
    )
  end

  def leading_whitespace_again
    mail(
      to:       "foo@example.com",
      reply_to: "noreply@schneems.com",
      subject:  "hello world"
    )
  end

  def contact
    mail(
      to:       "foo@example.com",
      reply_to: "noreply@schneems.com",
      subject:  "hello world"
    )
  end
end
