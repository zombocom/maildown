module Maildown
  module MarkdownEngine
    def self.to_html(string)
      Thread.current[:maildown_markdown_engine_block].call(string)
    end

    def self.set(&block)
      Thread.current[:maildown_markdown_engine_block] = block
    end

    def self.block
      Thread.current[:maildown_markdown_engine_block]
    end
  end
end

Maildown::MarkdownEngine.set do |string|
  Kramdown::Document.new(string).to_html
end
