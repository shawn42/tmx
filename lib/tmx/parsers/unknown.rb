module Tmx
  module Parser

    #
    # The Unknown Parser is used to generate an error when the format
    # is not supported or unknown.
    #
    class Unknown
      attr_reader :options

      def initialize(options)
        @options = options
      end

      def parse(contents)
        raise "Unknown Parser Type: Could not find an available parser for format #{options[:format]}"
      end
    end

  end

  Parsers.default = Parser::Unknown

end