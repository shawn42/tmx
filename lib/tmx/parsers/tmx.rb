require 'nokogiri'
require 'zlib'
require 'base64'

module Tmx
  module Parser

    #
    # Parses the TMX formatted output from Tiled.
    #
    class Tmx
      attr_reader :options

      def initialize(options)
        @options = options
      end

      def parse(contents)
        results = Nokogiri::XML(contents)
        convert_to_hash(results)
      end

      private

      def convert_to_hash(xml)
        {
          "version" => map_attr(xml,"version").to_i,
          "orientation" => map_attr(xml,"orientation"),
          "width" => map_attr(xml,"width").to_i,
          "height" => map_attr(xml,"height").to_i,
          "tilewidth" => map_attr(xml,"tilewidth").to_i,
          "tileheight" => map_attr(xml,"tileheight").to_i,
          "properties" => map_properties(xml),
          "layers" => map_layers(xml)
        }
      end

      def map_attr(xml,name)
        xml.xpath("/map/@#{name}").text
      end

      def map_properties(xml)
        properties = {}
        xml.xpath("/map/properties/property").each do |property|
          properties[property.xpath("@name").text] = property.xpath("@value").text
        end
        properties
      end

      def map_layers(xml)
        layers = []

        xml.xpath("/map/layer").each do |layer|
          layer_hash = {}

          layer_hash["name"] = layer.xpath("@name").text
          layer_hash["width"] = layer.xpath("@width").text.to_i
          layer_hash["height"] = layer.xpath("@height").text.to_i

          # THESE ARE FIELDS THAT COULD BE UNSPECIFIED IN THE XML VERSION
          layer_hash["type"] = layer.xpath("@type").text == "" ? "tilelayer" : layer.xpath("@type").text
          layer_hash["visible"] = (layer.xpath("@visible").text =~ /^false$/ ? false : true)
          layer_hash["x"] = layer.xpath("@x").text.to_i
          layer_hash["y"] = layer.xpath("@y").text.to_i
          layer_hash["opacity"] = layer.xpath("@opacity").text == "" ? 1.0 : layer.xpath("@opacity").text.to_f

          layer_data = layer.xpath("data").text.strip

          if layer.xpath("data/@compression").text == "zlib"

            decompressed_data = Zlib::Inflate.inflate(Base64.decode64(layer_data))
            data = decompressed_data.unpack("V" * (decompressed_data.length / 4))

          elsif layer.xpath("data/@compression").text == "gzip"

            decompressed_data = Zlib::GzipReader.new(StringIO.new(Base64.decode64(layer_data))).read
            data = decompressed_data.unpack("V" * (decompressed_data.length / 4))

          elsif layer.xpath("data/@encoding").text == "csv"

            data = layer_data.split(",").map(&:to_i)

          elsif layer.xpath("data/@encoding").text == "base64"

            decompressed_data = Base64.decode64(layer_data)
            data = decompressed_data.unpack("V" * (decompressed_data.length / 4))

          else

            data = layer.xpath("data/tile").map { |tile| tile.xpath("@gid").text.to_i }

          end

          layer_hash["data"] = data

          layers.push layer_hash
        end
        layers
      end
    end

  end

  Parsers.register :tmx, Parser::Tmx
end