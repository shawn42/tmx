module Tmx
  module Exporter

    #
    # The Unknown Exporter is used to generate an error when the format
    # is not supported or unknown.
    #
    class Unknown
      attr_reader :options

      def initialize(options)
        @options = options
      end

      def parse(contents)
        raise "Unknown Exporter Type: Could not find an available exporter for format #{options[:format]}"
      end
    end

  end

  Exporters.default = Exporter::Unknown

end
