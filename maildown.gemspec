$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "maildown/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "maildown"
  s.version     = Maildown::VERSION
  s.authors     = ["schneems"]
  s.email       = ["richard.schneeman@gmail.com"]
  s.homepage    = "https://www.github.com/schneems/maildown"
  s.summary     = "Markdown in your mailbox"
  s.description = "Best practice is to send text/plain && text/html markdown works great for both, so why write your templates twices?"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.0.0"
  s.add_dependency "kramdown"

  s.add_development_dependency "sqlite3"
end
