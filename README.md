# Maildown

[Markdown](http://daringfireball.net/projects/markdown/syntax) for your ActionMailer generated emails

[![Build Status](https://travis-ci.org/schneems/maildown.png)](https://travis-ci.org/schneems/maildown)

## What?

- Fact: You should always send emails in `text/html` and `text/plain` at the same time
- Fact: Writing email body content twice sucks
- Fact: [Markdown](http://daringfireball.net/projects/markdown/syntax) is amazing

So why not write your templates once in markdown, and have them translated to text and html? With Maildown now you can.

## Install

Gemfile:

```
gem 'maildown'
```

Then run `$ bundle install`

## Use

In your `app/views<mailer>` directory create a file with a `.md.erb` extension. When rails renders the email, it will generate html by parsing the markdown, and generate plain text by sending the email as is.

## Verify

Once you've got a file named `.md.erb` in your mailer directory, I recommend verifing the format in your browser in development using a tool such as [mail_view](https://github.com/37signals/mail_view). You can toggle between html and text at the top to make sure both look like you expect.

## Helpers in Markdown files

View helpers in markdown such as `link_to` are not modified by this gem, so they will produce html style links `<a href="#..."></a>` instead of markdown style links `[]()`. It will only affect your plain text users (such as those using [mutt](http://www.mutt.org/), and is still better than not supporting text email at all).

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

This codebase depends on some metaprogramming to convince Action Mailer to render html and plain text from md. If you've got some ideas on how to add sane hooks into actionmailer to support this functionality more natively ping me [@schneems](http://twitter.com/schneems)

## License

MIT
