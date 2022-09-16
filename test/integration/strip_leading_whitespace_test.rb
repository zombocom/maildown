require "test_helper"

class TemplateHandlerTest < ActionDispatch::IntegrationTest
  def test_strip_whitespace_templates
    Maildown.allow_indentation = true
    email = UserNoLayoutMailer.leading_whitespace.deliver_now

    assert_equal 2, email.parts.size
    assert_equal "multipart/alternative", email.mime_type

    assert_equal "text/plain", email.text_part.mime_type
    assert_equal "## Leading\n", email.text_part.body.to_s

    assert_equal "text/html", email.html_part.mime_type
    assert_equal %(<h2 id="leading">Leading</h2>\n), email.html_part.body.to_s
  ensure
    Maildown.allow_indentation = false
  end

  test "dont whitespace templates" do
    Maildown.allow_indentation = false
    email = UserNoLayoutMailer.leading_whitespace_again.deliver_now

    assert_equal 2, email.parts.size
    assert_equal "multipart/alternative", email.mime_type

    assert_equal "text/plain", email.text_part.mime_type
    assert_equal "         ## Leading again\n", email.text_part.body.to_s

    assert_equal "text/html", email.html_part.mime_type
    assert_equal "<pre><code>     ## Leading again\n</code></pre>\n", email.html_part.body.to_s
  end
end
