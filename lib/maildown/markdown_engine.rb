module Maildown
  module MarkdownEngine
    def self.to_html(string)
      block.call(string)
    end

    def self.set(&block)
      @maildown_markdown_engine_block = block
    end

    def self.block
      @maildown_markdown_engine_block || default
    end

    def self.default
      require 'kramdown' unless defined? Kramdown

      ->(string) { Kramdown::Document.new(string).to_html }
    end
  end
end
