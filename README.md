# Maildown

[Markdown](http://daringfireball.net/projects/markdown/syntax) for your ActionMailer generated emails. Supports Rails 4.0+

[![Build Status](https://travis-ci.org/schneems/maildown.png)](https://travis-ci.org/schneems/maildown)

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

## Verify

Once you've got a file named `.md.erb` in your mailer directory, I recommend verifing the format in your browser in development using a tool such as [mail_view](https://github.com/basecamp/mail_view). You can toggle between html and text at the top to make sure both look like you expect.

## Configure Markdown Renderer

Maildown uses [kramdown](https://github.com/gettalong/kramdown) by default.
Kramdown is pure ruby, so it runs the same across all ruby implementations:
jruby, rubinius, MRI, etc. You can configure another parser if you like using
the `Maildown::MarkdownEngine.set` method and pasing it a block.

For example, if you wanted to use Redcarpet you could set it like this:

```ruby
Maildown::MarkdownEngine.set do |text|
  carpet = Redcarpet::Markdown.new(Redcarpet::Render::HTML, {})
  carpet.render(text).html_safe
end
```

When maildown needs an html document the block will be called with the markdown
text. The result should be html.

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
