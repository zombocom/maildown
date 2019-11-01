# Maildown

[Markdown](http://daringfireball.net/projects/markdown/syntax) for your ActionMailer-generated emails. Supports Rails 5.0+

Also due to the way it's implemented it extends markdown support for any other view you want to look for. It could be called `markdown-rails` or something, but this is what I named the gem and I'm sticking with it.

[![Build Status](https://travis-ci.org/codetriage/maildown.svg?branch=schneems%2F2.0.0)](https://travis-ci.org/schneems/maildown)
[![Help Contribute to Open Source](https://www.codetriage.com/schneems/maildown/badges/users.svg)](https://www.codetriage.com/schneems/maildown)

## What?

- Fact: You should always send emails in `text/html` and `text/plain` at the same time
- Fact: Writing email body content twice sucks
- Fact: [Markdown](http://daringfireball.net/projects/markdown/syntax) is amazing

So why not write your templates once in markdown, and have them translated to text and HTML? With Maildown now you can.

## Install

Gemfile:

```ruby
gem 'maildown'
```

Then run `$ bundle install`

## Use

In your `app/views/<mailer>` directory create a file with a `.md`, `.md+erb` or `.md.erb` extension. When Rails renders the email, it will generate HTML by parsing the markdown, and generate plain text by sending the email as is.

Also if you skipped the part above, templates with these extensions can also be used outside of mail. For example you can have `app/views/welcome/index.md.erb` and it should work.

## Verify Installation

Once you've got a file named `.md.erb` in your mailer directory, I recommend verifying the format in your browser in development using a tool such as [mail_view](https://github.com/basecamp/mail_view). You can toggle between HTML and text at the top to make sure both look like you expect.

If you're going to style HTML emails, take a look at [premailer-rails](https://github.com/fphilipe/premailer-rails).

## Upgrading to version 3.0

In 3.0 a lot of the internals were re-tooled to monkeypatch less so they behave more like what you would expect.

The `Maildown::MarkdownEngine.set` is deprecated and and has been removed. Instead, use `Maildown::MarkdownEngine.set_html`.

Layouts are now used by default. This setting is deprecated and does nothing:

```ruby
Maildown.enable_layouts = true
```

There is no way to disable layouts via maildown, instead use normal Rails methods, such as moving to a mailer without a layout set.

## Features

### Different HTML/Text Layouts

In your mailer you can set a layout:

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

This does not currently work with format blocks in your mailer (AFAIK)

```ruby
# THIS DOES NOT WORK
mail(to: user.email) do |format|
  format.html { render layout: 'my_layout' }
  format.text
end
# THIS DOES NOT WORK
```

If you need to have different layouts for different views I suggest you make a different mailer.

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

This feature is hacky, and based off of removing whitespace before lines in your template (via regex 🙀).

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

When maildown needs an HTML document the block will be called with the markdown
text. The result should be HTML.

You can also customize the renderer for plain text. By default the text is
passed through unmodified, but you may wish to use Kramdown to strip HTML tags,
unify formatting etc.

```ruby
Maildown::MarkdownEngine.set_text do |text|
  Kramdown::Document.new(text).tap(&:to_remove_html_tags).to_kramdown
end
```

## Helpers in Markdown files

To get great looking emails in both HTML and plaintext, generate your own links like this:

```ruby
[Your Profile](<%= user_url(@user) %>)
```

Instead of

```ruby
<%= link_to "Your Profile", user_url(@user) %>
```

Bonus: it's shorter!

## Future

This codebase depends on some metaprogramming to convince Action Mailer to render html and plain text from md. If you've got some ideas on how to add sane hooks into actionmailer to support this functionality more natively ping me [@schneems](https://twitter.com/schneems).

## Alternative Implementations

There is another project that accomplishes roughly the same thing by plataformatec: [markerb](https://github.com/plataformatec/markerb).

Features we have that they don't:

- We support `md`, `md+erb` and `md.erb` file extensions. They only support `markerb` file extension.
- They require you manually add a block to each mailer with a text and HTML format, we don't.
- We allow you to strip templates with `Maildown.allow_indentation`.
- Their gem is unmaintained, but honestly it's pretty simple and will keep working for some time.
- We have way more monkeypatches than they do 🙀.


## Test

We use the appraisal gem to generate Gemfiles. Install all dependencies with this:

```
$ appraisal install
```

Run a specific suite like this:

```
$ BUNDLE_GEMFILE=gemfiles/rails_6.gemfile bundle exec rake test
```

## License

MIT
