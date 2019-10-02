# frozen_string_literal: true
require 'action_view'

module Maildown
  module Handlers
    # The handler is what allows Rails to render markdown
    #
    # See docs/rails_template_handler.pdf for detailed tutorial on
    # using a template handler with Rails.
    #
    # The TLDR; is you define a handler that responds to `call` and then
    # you register it against an file extension with `ActionView::Template.register_template_handler`
    #
    # At runtime if Rails finds a template with the same file extension that was
    # registered it will use you handler and pass the template into `call` to
    # render the template
    module Markdown
      def self.erb_handler
        @erb_handler ||= ActionView::Template.registered_template_handler(:erb)
      end

      # Expected return value is valid ruby code wrapped in a string.
      #
      # This handler takes care of both text and html email templates
      # by inspectig the available `"formats"` and rendering the
      # markdown to HTML if one of the formats is `:html`.
      def self.call(template, source = nil)
        # The interface of template handlers changed in Rails 6.0 and the
        # source is passed as an argument. This check is here for compatibility
        # with Rails 5.0+.
        source ||= template.source

        # Match beginning whitespace but not newline http://rubular.com/r/uCXQ58OOC8
        source.gsub!(/^[^\S\n]+/, ''.freeze) if Maildown.allow_indentation

        compiled_source = if Rails.version > "6"
                            erb_handler.call(template, source)
                          else
                            erb_handler.call(template)
                          end

        if Rails.version > "6"
          if template.format == :html
            "Maildown::MarkdownEngine.to_html(begin;#{compiled_source}; end)"
          else
            "Maildown::MarkdownEngine.to_text(begin;#{compiled_source}; end)"
          end
        else
          if template.formats.include?(:html)
            "Maildown::MarkdownEngine.to_html(begin;#{compiled_source}; end)"
          else
            "Maildown::MarkdownEngine.to_text(begin;#{compiled_source}; end)"
          end
        end
      end
    end
  end
end

# Allows for templates like `contact.md` or `contact.md+erb` to be rendered as
# markdown.
ActionView::Template.register_template_handler :"md+erb", Maildown::Handlers::Markdown
ActionView::Template.register_template_handler :"md",     Maildown::Handlers::Markdown

# Used in conjunction with ext/action_view.rb monkey patch
# to allow for using the ".md.erb" file "extension".
#
# Rails only considers the last part of the file extension
# i.e the "erb" from "md.erb" to be an extension.
#
# The monkeypatch in `ext/action_view.rb` detects "md.erb" and converts
# it to md+erb which is an extension with a "variant". However
# to allow rails to even attempt to process the file, it needs this
# handler with ".md.erb" to be registered.
ActionView::Template.register_template_handler :"md.erb", Maildown::Handlers::Markdown
