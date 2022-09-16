require "test_helper"

class ExtActionMailerTest < ActiveSupport::TestCase
  test "monkeypatch location" do
    monkeypatch = ActionMailer::Base.instance_method(:each_template)
    path = monkeypatch.source_location.first
    assert_match "maildown/ext/action_mailer.rb", path
  end
end
