module Tmx

  #
  # This module defines the exporters for the formats of various
  # TMX output formats.
  #
  module Exporters
    extend self

    def format(format)
      exporters[format]
    end

    def exporters
      @exporters ||= {}
    end

    def register(format,exporter)
      exporters[format] = exporter
    end

    def default=(exporter)
      exporters.default = exporter
    end
  end
end

require "tmx/exporters/unknown"
require "tmx/exporters/json"
