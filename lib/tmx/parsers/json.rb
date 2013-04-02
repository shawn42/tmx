require 'oj'

module Tmx
  module Parser

    #
    # Parses the JSON formatted output from Tiled.
    #
    class Json
      attr_reader :options

      def initialize(options)
        @options = options
      end

      def parse(contents)
        Oj.load(contents)
      end
    end

  end

  Parsers.register :json, Parser::Json
end