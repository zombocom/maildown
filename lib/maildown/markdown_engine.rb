require 'active_support'

module Maildown
  module MarkdownEngine
    def self.to_html(string)
      html_block.call(string)
    end

    def self.to_text(string)
      text_block.call(string)
    end

    def self.set(&block)
      set_html(&block)
    end
    singleton_class.deprecate set: :set_html

    def self.set_html(&block)
      @maildown_markdown_engine_html_block = block
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
      require 'kramdown' unless defined? Kramdown

      ->(string) { Kramdown::Document.new(string).to_html }
    end

    def self.default_text_block
      ->(string) { string }
    end
  end
end
