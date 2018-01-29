module Maildown
  class Md
    attr_accessor :string

    # responses is an array of hashes containing a body: and :content_type
    def initialize(responses)
      @responses  = responses.reject {|r| r[:content_type] == Mime[:html].to_s || r[:content_type] == Mime[:text].to_s }
      md_response = responses.detect {|r| r[:content_type] == Mime[:md].to_s }
      if md_response.present?
        @string = md_response[:body]
        # Match beginning whitespace but not newline http://rubular.com/r/uCXQ58OOC8
        @string.gsub!(/^[^\S\n]+/, ''.freeze) if Maildown.allow_indentation

        @responses.delete(md_response)
      end
    end

    def to_text
      Maildown::MarkdownEngine.to_text(string)
    end

    def to_html
      Maildown::MarkdownEngine.to_html(string)
    end

    def to_responses
      [
        { body: to_text, content_type: "text/plain"},
        { body: to_html, content_type: "text/html"}
      ].concat(@responses)
    end


    def contains_md?
      string.present?
    end
  end
end
