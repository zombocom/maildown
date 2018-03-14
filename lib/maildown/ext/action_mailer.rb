# frozen_string_literal: true

require 'action_mailer'
require 'action_mailer/base'

# Monkeypatch to allow mailer to auto generate text/html
#
# If you generate a mailer action, by default it will only
# render an html email:
#
#   def welcome
#     mail(
#       to:       "foo@example.com",
#       reply_to: "noreply@schneems.com",
#       subject:  "hello world"
#     )
#   end
#
# You can add a format block to have it produce html
# and text emails:
#
#   def welcome
#     mail(
#       to:       "foo@example.com",
#       reply_to: "noreply@schneems.com",
#       subject:  "hello world"
#     ) do |format|
#      format.text
#      format.html
#    end
#   end
#
# For the handler to work correctly and produce both HTML
# and text emails this would need to be required similar to
# how https://github.com/plataformatec/markerb works.
#
# This monkeypatch detects when a markdown email is being
# used and generates both a markdown and text template
class ActionMailer::Base
  alias :original_each_template :each_template

  def each_template(paths, name, &block)
    templates = original_each_template(paths, name, &block)

    return templates if templates.first.handler != Maildown::Handlers::Markdown

    html_template = templates.first
    text_template = html_template.dup
    formats = html_template.formats.dup.tap { |f| f.delete(:html) }

    text_template.formats = formats
    return [html_template, text_template]
  end
end
