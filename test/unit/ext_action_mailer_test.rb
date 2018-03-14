require 'test_helper'

class ExtActionMailerTest < ActiveSupport::TestCase

  test "monkeypatch location" do
    monkeypatch = ActionMailer::Base.instance_method(:each_template)
    path        = monkeypatch.source_location.first
    assert_match "maildown/ext/action_mailer.rb", path

    monkeypatch = ActionView::OptimizedFileSystemResolver.instance_method(:extract_handler_and_format_and_variant)
    path        = monkeypatch.source_location.first
    assert_match "maildown/ext/action_view.rb", path
  end
end
