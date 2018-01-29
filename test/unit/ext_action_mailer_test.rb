require 'test_helper'

class ExtActionMailerTest < ActiveSupport::TestCase

  test "correctly registered md mime type" do
    assert_equal Mime[:md], Mime::Type.lookup("text/md")
    assert_equal "text/md", Mime[:md].to_s
  end

  test "default types on action mailer base" do
    actual   = ActionMailer::Base.view_context_class.default_formats
    assert_equal actual.include?(:md), true, "Expected #{actual.inspect} to include :md but it did not"
  end

  test "monkeypatch location" do
    monkeypatch = ActionMailer::Base.instance_method(:collect_responses)
    path        = monkeypatch.source_location.first
    assert_match "maildown/ext/action_mailer.rb", path
  end
end
