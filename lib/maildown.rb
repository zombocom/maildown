# Top level module, all module methods are used for configuration
module Maildown
  @allow_indentations = false
  @enable_layouts     = false

  def self.allow_indentation
    @allow_indentations
  end

  def self.allow_indentation=(allow_indentations)
    @allow_indentations = allow_indentations
  end

  def self.enable_layouts
    puts "Maildown.enable_layouts is deprecated, setting this does nothing"
    @enable_layouts
  end

  def self.enable_layouts=(enable_layouts)
    puts "Maildown.enable_layouts= is deprecated, setting this does nothing"
    @enable_layouts = enable_layouts
  end
end

require 'maildown/markdown_engine'
require 'maildown/ext/action_mailer'
require 'maildown/ext/action_view'
require 'maildown/handlers/markdown'
