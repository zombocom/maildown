# Top level module, all module methods are used for configuration
module Maildown
  @allow_indentations = false
  @enable_layouts = false

  def self.allow_indentation
    @allow_indentations
  end

  def self.allow_indentation=(allow_indentations)
    @allow_indentations = allow_indentations
  end

  def self.rails_6?
    @rails_6 ||= Rails.version > "6"
  end
end

require "maildown/markdown_engine"
ActiveSupport.on_load(:action_mailer) do
  require "maildown/ext/action_mailer"
end
ActiveSupport.on_load(:action_view) do
  require "maildown/ext/action_view"
end
require "maildown/handlers/markdown"
