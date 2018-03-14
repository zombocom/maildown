require 'test_helper'

class LayoutsTest < ActionMailer::TestCase

  def test_no_layout
    email = UserNoLayoutMailer.welcome.deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    # Test the body of the sent email contains what we expect it to
    assert_equal ["foo@example.com"], email.to
    assert_equal "hello world",       email.subject

    body_contents = /<h2 id="welcome">Welcome!<\/h2>/
    assert_match body_contents,       email.html_part.body.to_s

    body_contents = /## Welcome!/
    assert_match body_contents,       email.text_part.body.to_s
  end

  def test_layout_renders_fine
    email = UserWithLayoutMailer.welcome.deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    # Test the body of the sent email contains what we expect it to
    assert_equal ["foo@example.com"], email.to
    assert_equal "hello world",       email.subject

    body_contents = /HTML<h2 id="welcome">Welcome!<\/h2>/
    assert_match body_contents,       email.html_part.body.to_s

    body_contents = /TEXT## Welcome!/
    assert_match body_contents,       email.text_part.body.to_s
  end
end
