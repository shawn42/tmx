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
          "properties" => properties(xml.xpath("/map")),
          "layers" => map_layers(xml),
          "tilesets" => map_tilesets(xml)
        }
      end

      def map_attr(xml,name)
        xml.xpath("/map/@#{name}").text
      end

      def properties(xml)
        properties = {}
        xml.xpath("properties/property").each do |property|
          properties[property.xpath("@name").text] = property.xpath("@value").text
        end
        properties
      end

      def layer_attr(layer,name,options)
        layer.xpath("@#{name}").text == "" ? options[:default] : layer.xpath("@#{name}").text
      end

      def map_layers(xml)
        layers = []

        xml.xpath("/map/layer").each do |layer|
          layer_hash = {}

          layer_hash["name"] = layer.xpath("@name").text
          layer_hash["width"] = layer.xpath("@width").text.to_i
          layer_hash["height"] = layer.xpath("@height").text.to_i

          layer_hash["type"] = layer_attr(layer,"type",default: "tilelayer")
          layer_hash["opacity"] = layer_attr(layer,"opacity",default: 1.0).to_f
          layer_hash["visible"] = (layer.xpath("@visible").text =~ /^false$/ ? false : true)

          layer_hash["x"] = layer.xpath("@x").text.to_i
          layer_hash["y"] = layer.xpath("@y").text.to_i

          layer_hash["data"] = data_from_layer(layer)

          layers.push layer_hash
        end
        layers
      end

      def data_from_layer(layer)
        layer_data = layer.xpath("data").text.strip

        if layer.xpath("data/@encoding").text == "base64"
          layer_data = Base64.decode64(layer_data)
        end

        if layer.xpath("data/@compression").text == "zlib"
          data = unpack_data zlib_decompress(layer_data)
        elsif layer.xpath("data/@compression").text == "gzip"
          data = unpack_data gzip_decompress(layer_data)
        elsif layer.xpath("data/@encoding").text == "base64"
          data = unpack_data(layer_data)
        elsif layer.xpath("data/@encoding").text == "csv"
          data = layer_data.split(",").map(&:to_i)
        else
          data = layer.xpath("data/tile").map { |tile| tile.xpath("@gid").text.to_i }
        end
      end

      def zlib_decompress(data)
        Zlib::Inflate.inflate(data)
      end

      def gzip_decompress(data)
        Zlib::GzipReader.new(StringIO.new(data)).read
      end

      #
      # Convert the XML data format into a valid format in Ruby.
      #
      # @see http://sourceforge.net/apps/mediawiki/tiled/index.php?title=Examining_the_map_format
      # @see http://www.ruby-doc.org/core-2.0/String.html#method-i-unpack
      #
      #     V         | Integer | 32-bit unsigned, VAX (little-endian) byte order
      #
      def unpack_data(data)
        data.unpack("V" * (data.length / 4))
      end

      def map_tilesets(xml)
        xml.xpath("map/tileset").map do |tileset|
          image = tileset.xpath("image")

          properties = {
            "firstgid" => tileset.xpath("@firstgid").text.to_i,
            "name" => tileset.xpath("@name").text,
            "tilewidth" => tileset.xpath("@tilewidth").text.to_i,
            "tileheight" => tileset.xpath("@tileheight").text.to_i,
            "spacing" => tileset.xpath("@spacing").text.to_i,
            "margin" => tileset.xpath("@margin").text.to_i,
            "image" => image.xpath("@source").text,
            "imageheight" => image.xpath("@height").text.to_i,
            "imagewidth" => image.xpath("@width").text.to_i,
            "properties" => properties(xml)
          }
        end


      end

    end

  end

  Parsers.register :tmx, Parser::Tmx
end