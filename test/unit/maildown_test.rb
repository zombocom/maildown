require 'test_helper'

class MaildownTest < ActiveSupport::TestCase
  test "parse md response" do
    md = ::Maildown::Md.new(full_responses)
    assert md.contains_md?
    assert_equal parses_responses, md.to_responses
  end


  test "allow indentation strips leading whitespace" do
    Maildown.allow_indentation = true

    string = "foo"

    md = ::Maildown::Md.new(string_to_response_array("\n    #{string}"))
    assert md.contains_md?

    expected = [{
                 body:         "\n#{string}",
                 content_type: "text/plain"
                },
                {
                 body:         "\n<p>#{string}</p>\n",
                 content_type: "text/html"
                }]
    assert_equal expected, md.to_responses
  ensure
    Maildown.allow_indentation = false
  end

  test "whitespace is not stripped by default" do
    string = "foo"

    md = ::Maildown::Md.new(string_to_response_array("    #{string}"))
    assert md.contains_md?

    expected = [{
                 body:         "    #{string}",
                 content_type: "text/plain"
                },
                {
                 body:         "<pre><code>foo\n</code></pre>\n",
                 content_type: "text/html"
                }]
    assert_equal expected, md.to_responses
  end

  test "no md in response" do
    md = ::Maildown::Md.new([])
    refute md.contains_md?
  end
end
