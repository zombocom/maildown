# Maildown

[Markdown](http://daringfireball.net/projects/markdown/syntax) for your ActionMailer generated emails. Supports Rails 5.0+

[![Build Status](https://travis-ci.org/schneems/maildown.svg?branch=schneems%2F2.0.0)](https://travis-ci.org/schneems/maildown)
[![Help Contribute to Open Source](https://www.codetriage.com/schneems/maildown/badges/users.svg)](https://www.codetriage.com/schneems/maildown)

## What?

- Fact: You should always send emails in `text/html` and `text/plain` at the same time
- Fact: Writing email body content twice sucks
- Fact: [Markdown](http://daringfireball.net/projects/markdown/syntax) is amazing

So why not write your templates once in markdown, and have them translated to text and html? With Maildown now you can.

## Install

Gemfile:

```ruby
gem 'maildown'
```

Then run `$ bundle install`

## Use

In your `app/views/<mailer>` directory create a file with a `.md.erb` extension. When rails renders the email, it will generate html by parsing the markdown, and generate plain text by sending the email as is.

## Verify Installation

Once you've got a file named `.md.erb` in your mailer directory, I recommend verifing the format in your browser in development using a tool such as [mail_view](https://github.com/basecamp/mail_view). You can toggle between html and text at the top to make sure both look like you expect.

## Advanced Features

### Different HTML/Text Layouts

The way layouts work with the Rails mailer is they're based on your content type. Since our source file is a `.md.erb` it will automatically use a markdown layout as well. That's fine if you want a markdown layout, but what if you want to add styles to only your HTML email?

Enable this feature and you can use HTML layouts:

```ruby
Maildown.enable_layouts = true
```

Now in your mailer you can set a layout:

```ruby
class UserMailer < ActionMailer::Base
  layout "mail_layout"

  # ...
```

Now when your render a markdown email it will look for `layouts/mail_layout.html.erb` and `layouts/mail_layout.text.erb` files.

Here's an example of a styled HTML layout

```erb
<% # layouts/mail_layout.html.erb %>
<%= stylesheet_link_tag "markdown.css" %>

<div class="readme">
  <article class="markdown-body">
    <%= yield %>
  </article>
</div>
```

You can leave the text version plain if you want, but don't forget to add a `yield` or it won't render

```erb
<%= yield %>
```

This does not currently work with format blocks in your mailer

```ruby
# THIS DOES NOT WORK
mail(to: user.email) do |format|
  format.html { render layout: 'my_layout' }
  format.text
end
# THIS DOES NOT WORK
```

If you need to have different layouts for different views I suggest you make a different mailer.

This layout mechanism may behave differently than you are used to. For example the layout actually gets added after your main view is rendered. This means you cannot mutate variables in your layout and expect that to show up in your view.

Also the ERB template still works in tandem with this feature. However, it gets applied before any HTML or TEXT templates.

This whole library is a giant pile of hacks, so this might not behave as you want.

### Indentation

In markdown when you indent your text it gets treated as a code block. This means if you're looping or branching in your markdown view, you cannot indent your code if you want it to show up fine. You end up writing code that looks like this:

```
<% if @write_docs.present? %>
## Write Docs

<% @write_docs.sort_by {|d| d.repo.full_name }.each do |doc| %>
**<%= doc.repo.full_name %>** ([source](<%= doc.to_github %>)): [<%= doc.path %>](<%= doc_method_url doc %>)

<% end %>
<% end %>
```

Gross.

To get around this, you can set this flag:

```ruby
Maildown.allow_indentation = true
```

Now you can indent your code:

```
<% if @write_docs.present? %>
  ## Write Docs

    <% @write_docs.sort_by {|d| d.repo.full_name }.each do |doc| %>
    **<%= doc.repo.full_name %>** ([source](<%= doc.to_github %>)): [<%= doc.path %>](<%= doc_method_url doc %>)

  <% end %>
<% end %>
```

If you want to use a code block, you can use backticks instead of indentation:

    ```
    This is a code block using backticks
    ```

This feature is really hacky, and based off of removing whitespace before lines (via regex 🙀). So if you need beginning whitespace preserved in any area, this feature will not work for you.

In the future I hope to have a better way of doing this, but for now it's all you get.

## Configure Markdown Renderer

Maildown uses [kramdown](https://github.com/gettalong/kramdown) by default.
Kramdown is pure ruby, so it runs the same across all ruby implementations:
jruby, rubinius, MRI, etc. You can configure another parser if you like using
the `Maildown::MarkdownEngine.set_html` method and pasing it a block.

For example, if you wanted to use Redcarpet you could set it like this:

```ruby
Maildown::MarkdownEngine.set_html do |text|
  carpet = Redcarpet::Markdown.new(Redcarpet::Render::HTML, {})
  carpet.render(text).html_safe
end
```

When maildown needs an html document the block will be called with the markdown
text. The result should be html.

You can also customize the renderer for plain text. By default the text is
passed through unmodified, but you may wish to use Kramdown to strip HTML tags,
unify formatting etc.

```ruby
Maildown::MarkdownEngine.set_text do |text|
  Kramdown::Document.new(text).tap(&:to_remove_html_tags).to_kramdown
end
```

## Helpers in Markdown files

To get great looking emails in both html and plaintext generate your own links like this:

```ruby
[Your Profile](<%= user_url(@user) %>)
```

Instead of

```ruby
<%= link_to "Your Profile", user_url(@user) %>
```

Bonus: it's shorter!

## Future

This codebase depends on some metaprogramming to convince Action Mailer to render html and plain text from md. If you've got some ideas on how to add sane hooks into actionmailer to support this functionality more natively ping me [@schneems](https://twitter.com/schneems)


## Alternative Implementations

There is another project that accomplishes the same thing by plataformatec: [markerb](https://github.com/plataformatec/markerb).

## License

MIT
