require 'action_mailer'

mail_view_klass = ActionMailer::Base.view_context_class
mail_view_klass.default_formats = (mail_view_klass.default_formats << :md)
Mime::Type.register "text/md", :md, [], %w(md)

class ActionMailer::Base
  alias :original_collect_responses :collect_responses

  def collect_responses(*args, &block)
    responses = original_collect_responses(*args, &block)
    md = ::Maildown::Md.new(responses)
    if md.contains_md?
      rendered_response = md.to_responses

      if Maildown.enable_layouts
        text = rendered_response[0]
        html = rendered_response[1]

        layout_name   = _layout(text[:content_type])
        text[:layout] = "#{layout_name}.text.erb"
        text[:body]   = render(text)

        layout_name   = _layout(html[:content_type])
        html[:layout] = "#{layout_name}.html.erb"
        html[:body]   = render(html)
      end

      return rendered_response
    else
      return responses
    end
  end
end
