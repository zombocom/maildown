require 'test_helper'

class TemplateHandlerTest < ActionDispatch::IntegrationTest
  test ".md template handler" do
    get "/handlers/plain_markdown"
    expected = "<p>Hello</p>"
    assert_match expected, response.body
  end

  test "dual templates" do
    email = UserNoLayoutMailer.contact.deliver_now

    assert_equal 2, email.parts.size
    assert_equal "multipart/alternative", email.mime_type

    assert_equal "text/plain", email.text_part.mime_type
    assert_match "Dual templates **rock**!", email.text_part.body.to_s

    assert_equal "text/html", email.html_part.mime_type
    assert_match "<p>Dual templates <strong>rock</strong>!</p>", email.html_part.body.to_s
  end
end
