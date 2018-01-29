# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"
require "kramdown"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

# Load fixtures from the engine
# if ActiveSupport::TestCase.method_defined?(:fixture_path=)
#   ActiveSupport::TestCase.fixture_path = File.expand_path("../fixtures", __FILE__)
# end


def default_body
  "Hi,\n\n##\n\n\nName:\n  test_to_yaml_with_time_with_zone_should_not_raise_exception\nLocation:\n  https://github.com/rails/rails/blob/master/test/cases/yaml_serialization_test.rb/#L7\nName:\n  test_roundtrip\nLocation:\n  https://github.com/rails/rails/blob/master/test/cases/yaml_serialization_test.rb/#L20\nName:\n  test_roundtrip_serialized_column\nLocation:\n  https://github.com/rails/rails/blob/master/test/cases/yaml_serialization_test.rb/#L27\nName:\n  test_encode_with_coder\nLocation:\n  https://github.com/rails/rails/blob/master/test/cases/yaml_serialization_test.rb/#L32\nName:\n  test_psych_roundtrip\nLocation:\n  https://github.com/rails/rails/blob/master/test/cases/yaml_serialization_test.rb/#L39\nName:\n  test_psych_roundtrip_new_object\nLocation:\n  https://github.com/rails/rails/blob/master/test/cases/yaml_serialization_test.rb/#L46\n\n--\n@schneems\n"
end

def orig_text_response
  {
    :body         => default_body,
    :content_type => "text/plain"
  }.dup
end

def orig_html_response
  {
    :body         => default_body,
    :content_type => "text/html"
  }.dup
end

def md_response
  {
    :body         => default_body,
    :content_type => "text/md"
  }.dup
end

def full_responses
  [orig_text_response, orig_html_response, md_response].dup
end

def parsed_html_response
  {
    body:         Kramdown::Document.new(orig_text_response[:body]).to_html,
    content_type: "text/html"
  }
end

def string_to_response_array(string)
  [
    {
      body:         string,
      content_type: "text/plain"
    }.dup,
    {
      body:         string,
      content_type: "text/html"
    }.dup,
    {
      body:         string,
      content_type: "text/md"
    }.dup,
  ]
end

def parses_responses
  [orig_text_response, parsed_html_response]
end
