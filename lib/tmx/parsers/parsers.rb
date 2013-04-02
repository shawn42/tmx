module Tmx

  #
  # This module defines the parsers for the formats of various
  # TMX output formats.
  #
  module Parsers
    extend self

    def format(format)
      parsers[format]
    end

    def parsers
      @parsers ||= {}
    end

    def register(format,parser)
      parsers[format] = parser
    end

    def default=(parser)
      parsers.default = parser
    end
  end
end

require 'tmx/parsers/unknown'
require 'tmx/parsers/json'
require 'tmx/parsers/tmx'