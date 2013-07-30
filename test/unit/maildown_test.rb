require 'test_helper'

class MaildownTest < ActiveSupport::TestCase
  test "parse md response" do
    md = ::Maildown::Md.new(full_responses)
    assert md.contains_md?
    assert_equal parses_responses, md.to_responses
  end


  test "no md in response" do
    md = ::Maildown::Md.new([])
    refute md.contains_md?
  end
end
