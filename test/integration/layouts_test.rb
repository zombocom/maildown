require 'test_helper'

class LayoutsTest < ActionMailer::TestCase

  def test_welcome_email
    email = UserNoLayoutMailer.welcome.deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    # Test the body of the sent email contains what we expect it to
    body_contents = /<h2 id="welcome">Welcome!<\/h2>/
    assert_equal ["foo@example.com"], email.to
    assert_equal "hello world",       email.subject
    assert_match body_contents,       email.html_part.to_s
  end
end