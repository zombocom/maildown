module Maildown
  class Md
    attr_accessor :string

    # responses is an array of hashes containing a body: and :content_type
    def initialize(responses)
      @responses  = responses.reject {|r| r[:content_type] == Mime::HTML.to_s || r[:content_type] == Mime::TEXT.to_s }
      md_response = responses.detect {|r| r[:content_type] == Mime::MD.to_s }
      if md_response.present?
        @string = md_response[:body]
        @responses.delete(md_response)
      end
    end

    def to_text
      string
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