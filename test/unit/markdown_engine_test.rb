require 'test_helper'

class MarkdownEngineTest < ActiveSupport::TestCase

  def setup
    @default_setup = Maildown::MarkdownEngine.html_block
  end

  def teardown
    Maildown::MarkdownEngine.set_html(&@default_setup)
  end

  test "can set engine" do
    Maildown::MarkdownEngine.set_html do |text|
      "foo: #{text}"
    end
    assert_equal "foo: bar", Maildown::MarkdownEngine.to_html("bar")
  end

  test "default works in multiple threads" do
    thread = Thread.new do
      assert_equal "<p>bar</p>\n", Maildown::MarkdownEngine.to_html("bar")
    end
    thread.join
  end

  test "custom engine works in multiple threads" do
    Maildown::MarkdownEngine.set_html do |text|
      "foo: #{text}"
    end

    thread = Thread.new do
      assert_equal "foo: bar", Maildown::MarkdownEngine.to_html("bar")
    end
    thread.join
  end

  test "handles code fences (GFM)" do
    markdown = "```\nbar\n```"

    assert_equal "<pre><code>bar\n</code></pre>", Maildown::MarkdownEngine.to_html(markdown)
  end
end
