require 'test_helper'

class DoubleCompileTest < ActionMailer::TestCase

  def test_rendering_the_same_layout_twice_works
    email = UserNoLayoutMailer.welcome.deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    # Test the body of the sent email contains what we expect it to

    body_contents = /<h2 id="welcome">Welcome!<\/h2>/
    assert_match body_contents,       email.html_part.body.to_s

    body_contents = /## Welcome!/
    assert_match body_contents,       email.text_part.body.to_s

    email = UserNoLayoutMailer.welcome.deliver_now
    assert !ActionMailer::Base.deliveries.empty?
    # Test the body of the sent email contains what we expect it to

    body_contents = /<h2 id="welcome">Welcome!<\/h2>/
    assert_match body_contents,       email.html_part.body.to_s

    body_contents = /## Welcome!/
    assert_match body_contents,       email.text_part.body.to_s
  end
end