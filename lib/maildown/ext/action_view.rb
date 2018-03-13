require 'action_view/template'

module Maildown::TemplateExt
  def initialize(source, identifier, handler, details)
    return super unless Maildown.allow_indentation
    return super unless details[:format] == 'text/md'.freeze

    source.gsub!(/^[^\S\n]+/, ''.freeze)
    super
  end
end
