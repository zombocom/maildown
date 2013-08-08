require 'test_helper'

class MarkdownEngineTest < ActiveSupport::TestCase

  def setup
    @default_setup = Maildown::MarkdownEngine.block
  end

  def teardown
    Maildown::MarkdownEngine.set(&@default_setup)
  end

  test "can set engine" do
    Maildown::MarkdownEngine.set do |text|
      "foo: #{text}"
    end
    assert_equal "foo: bar", Maildown::MarkdownEngine.to_html("bar")
  end
end
