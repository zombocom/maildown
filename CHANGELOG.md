## HEAD (Unreleased)

## 3.3.0

- Delay loading of ActionMailer to fix support for `delivery_job` config (https://github.com/codetriage/maildown/pull/56)

## 3.2.0

- Switch to "github style markdown" (https://github.com/codetriage/maildown/pull/54)

## 3.1.0

- Support for Rails 6 (https://github.com/schneems/maildown/pull/50)

## 3.0.3

- Remove an Action View deprecation in Rails 6 (https://github.com/schneems/maildown/pull/45)

## 3.0.2

- Fix race condition maybe? (#41)
- Fix warning (#42)

## 3.0.1

- Fix issue that would cause the text part of emails to not render after the first email was sent #39

## 3.0.0

In 3.0 a lot of the internals were re-tooled to monkeypatch less so they behave more like what you would expect.

The `Maildown::MarkdownEngine.set` was deprecated and is removed. instead use `Maildown::MarkdownEngine.set_html`.

Layouts are now used by default. This setting is deprecated and does nothing:

```ruby
Maildown.enable_layouts = true
```

There is no way to disable layouts via maildown, instead use normal Rails methods, such as moving to a mailer without a layout set.

## 2.0.3

- Add support for using a different template for HTML and TEXT parts of the markdown email. Enable with `Maildown.enable_layouts = true`.

## 2.0.2

- Add support for "allow indentation". When `Maildown.allow_indentation = true`. This allows erb markdown templates to be indented but disables blockquotes via spaces. More information is available in the readme.

## 2.0.1

???

## 2.0.0

- Drop official support for 1.9. It still works on my machine but
  we aren't testing on travis anymore.
- Fix mime types warnings (#18)

## 1.1.0

- Kramdown loads during runtime if no other parser has been configured.

## 1.0.2

- Fix threading issue with default parser

## 1.0.0

- Allow configurable markdown parser.

## 0.0.1

- Initial Release.
