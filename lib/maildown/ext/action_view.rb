# frozen_string_literal: true

# This monkeypatch allows the use of `.md.erb` file extensions
# in addition to `.md+erb` and `.md`
#
# The calls to `ActionView::Template.register_template_handler`
# prior to Rails 7 will only consider the last extension in a file
# so if a file is labeled `foo.md.erb` the it will be treated as a
# `.erb` file. This hack internally converts `.md.erb` files to
# `.md+erb` which older versions of Rails will recognize.
if defined?(ActionView::OptimizedFileSystemResolver)
  module ActionView
    class OptimizedFileSystemResolver
      alias :original_extract_handler_and_format_and_variant :extract_handler_and_format_and_variant

      # Different versions of rails have different
      # method signatures here, path is always first
      def extract_handler_and_format_and_variant(*args)
        if args.first.end_with?('md.erb')
          path = args.shift
          path = path.gsub(/\.md\.erb\z/, '.md+erb')
          args.unshift(path)
        end
        return original_extract_handler_and_format_and_variant(*args)
      end
    end
  end
end
