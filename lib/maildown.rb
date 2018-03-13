module Maildown
  @allow_indentations = false
  @enable_layouts     = false

  def self.allow_indentation
    @allow_indentations
  end

  def self.allow_indentation=(allow_indentations)
    @allow_indentations = allow_indentations
    if allow_indentations
      ActionView::Template.send(:prepend, Maildown::TemplateExt)
    end
  end

  def self.enable_layouts
    @enable_layouts
  end

  def self.enable_layouts=(enable_layouts)
    @enable_layouts = enable_layouts
  end
end

require 'maildown/markdown_engine'
require 'maildown/md'
require 'maildown/ext/action_mailer'
require 'maildown/ext/action_view'
