# frozen_string_literal: true

if !defined?(ActionView::OptimizedFileSystemResolver)
  module ActionView
    # https://github.com/codetriage/maildown/issues/59
    #
    # extract_handler_and_format_and_variant was removed in https://github.com/rails/rails/commit/2be8d3ebf85e26e936a7717b968737ee333d95bd
    # OptimizedFileSystemResolver was removed in https://github.com/rails/rails/commit/faac734387124c6d780dbfcfdab721b2f26ce865
    class OptimizedFileSystemResolver < FileSystemResolver
      def extract_handler_and_format_and_variant(template)
        details = @path_parser.parse(template)
        [details.handler, details.format, details.variant]
      end
    end
  end
end

# This monkeypatch allows the use of `.md.erb` file extensions
# in addition to `.md+erb` and `.md`
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
