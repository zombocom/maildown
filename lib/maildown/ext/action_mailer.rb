mail_view_klass = ActionMailer::Base.view_context_class
mail_view_klass.default_formats = (mail_view_klass.default_formats << :md)
Mime::Type.register "text/md", :md, [], %w(md)

class ActionMailer::Base
  alias :original_collect_responses :collect_responses

  def collect_responses(*args)
    responses = original_collect_responses(*args)
    md = ::Maildown::Md.new(responses)
    if md.contains_md?
      return md.to_responses
    else
      return responses
    end
  end
end
