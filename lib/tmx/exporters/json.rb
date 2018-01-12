module Tmx
  module Exporter

    class Json
      attr_reader :options

      def initialize(options)
        @options = options
      end

      def export(map)
      end
    end
  end

  Exporters.register :json, Exporter::Json
end
