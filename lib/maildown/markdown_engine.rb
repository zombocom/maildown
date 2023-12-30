# frozen_string_literal: true

module Maildown
  # This module provides the API for Replacing the Markdown engine
  #
  # Maildown uses [kramdown](https://github.com/gettalong/kramdown) by default.
  # Kramdown is pure ruby, so it runs the same across all ruby implementations:
  # jruby, rubinius, MRI, etc. You can configure another parser if you like using
  # the `Maildown::MarkdownEngine.set_html` method and pasing it a block.
  #
  # For example, if you wanted to use Redcarpet you could set it like this:
  #
  #   Maildown::MarkdownEngine.set_html do |text|
  #     carpet = Redcarpet::Markdown.new(Redcarpet::Render::HTML, {})
  #     carpet.render(text).html_safe
  #   end
  #
  module MarkdownEngine
    @maildown_markdown_engine_html_block = nil
    @maildown_markdown_engine_text_block = nil

    def self.to_html(string)
      if string.is_a?(ActionView::OutputBuffer)
        string = string.to_s
      end
      html_block.call(string)
    end

    def self.to_text(string)
      if string.is_a?(ActionView::OutputBuffer)
        string = string.to_s
      end
      text_block.call(string)
    end

    def self.set_html(&block)
      @maildown_markdown_engine_html_block = block
    end

    def self.set(&block)
      set_html(&block)
    end

    def self.set_text(&block)
      @maildown_markdown_engine_text_block = block
    end

    def self.html_block
      @maildown_markdown_engine_html_block || default_html_block
    end

    def self.text_block
      @maildown_markdown_engine_text_block || default_text_block
    end

    def self.default_html_block
      ->(string) { Kramdown::Document.new(string, input: "GFM").to_html }
    end

    def self.default_text_block
      ->(string) { string }
    end
  end
end

Maildown::MarkdownEngine.autoload(:"Kramdown", "kramdown")
