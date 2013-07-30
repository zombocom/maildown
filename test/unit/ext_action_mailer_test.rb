require 'test_helper'

class ExtActionMailerTest < ActiveSupport::TestCase

  test "correctly registered md mime type" do
    assert_equal Mime::MD, Mime::Type.lookup("text/md")
    assert_equal "text/md", Mime::MD.to_s
  end

  test "default types on action mailer base" do
    expected = [:html, :text, :js, :css, :ics, :csv, :png, :jpeg, :gif, :bmp, :tiff, :mpeg, :xml, :rss, :atom, :yaml, :multipart_form, :url_encoded_form, :json, :pdf, :zip, :md]
    assert_equal expected, ActionMailer::Base.view_context_class.default_formats
  end

  test "monkeypatch location" do
    monkeypatch = ActionMailer::Base.instance_method(:collect_responses)
    path        = monkeypatch.source_location.first
    assert_match "maildown/ext/action_mailer.rb", path
  end
end
