module Maildown
  def self.allow_indentations
    @allow_indentations
  end

  def self.allow_indentations=(allow_indentations)
    @allow_indentations = allow_indentations
  end
end

require 'maildown/markdown_engine'
require 'maildown/md'
require 'maildown/ext/action_mailer'
