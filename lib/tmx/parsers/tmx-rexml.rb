require 'rexml/document'
require 'rexml/xpath'
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
        results = REXML::Document.new(contents)
        convert_to_hash(results)
      end

      private      
      def convert_to_hash(xml)
        {
          "version"       => map_attr(xml,"version").to_i,
          "orientation"   => map_attr(xml,"orientation"),
          "width"         => map_attr(xml,"width").to_i,
          "height"        => map_attr(xml,"height").to_i,
          "tilewidth"     => map_attr(xml,"tilewidth").to_i,
          "tileheight"    => map_attr(xml,"tileheight").to_i,
          "properties"    => properties(REXML::XPath.first(xml, "/map")),
          "layers"        => map_layers(xml),
          "tilesets"      => map_tilesets(xml),
          "object_groups" => map_object_groups(xml),
          "image_layers"  => map_image_layers(xml)
        }
      end

      def map_attr(xml,name)
        REXML::XPath.first(xml, "/map").attributes[name]
      end

      def properties(xml)
        properties = {}
        REXML::XPath.each(xml, "properties/property") do |property|
          properties[property.attributes["name"]] = property.attributes["value"]
        end
        properties
      end

      def layer_attr(layer,name,options)
        layer.attributes["#{name}"] == "" ? options[:default] : layer.attributes["#{name}"]
      end

      def map_layers(xml)
        layers = []

        REXML::XPath.each(xml, "/map/layer") do |layer|
          layer_hash = {}

          layer_hash["name"] = layer.attributes["name"]
          layer_hash["width"] = layer.attributes["width"].to_i
          layer_hash["height"] = layer.attributes["height"].to_i

          layer_hash["type"] = layer_attr(layer,"type",default: "tilelayer")
          layer_hash["opacity"] = layer_attr(layer,"opacity",default: 1.0).to_f
          layer_hash["visible"] = to_boolean(layer.attributes["visible"])

          layer_hash["x"] = layer.attributes["x"].to_i
          layer_hash["y"] = layer.attributes["y"].to_i

          layer_hash["data"] = data_from_layer(layer)
          layer_hash["properties"] = properties(layer)

          layers.push layer_hash
        end
        layers
      end

      def data_from_layer(layer)
        layer_data = REXML::XPath.first(layer, "data").text.strip
        data = REXML::XPath.first(layer, "data")
        
        if data.attributes["encoding"] == "base64"
          layer_data = Base64.decode64(layer_data)
        end

        if data.attributes["compression"] == "zlib"
          data = unpack_data zlib_decompress(layer_data)
        elsif data.attributes["compression"] == "gzip"
          data = unpack_data gzip_decompress(layer_data)
        elsif data.attributes["encoding"] == "base64"
          data = unpack_data(layer_data)
        elsif data.attributes["encoding"] == "csv"
          data = layer_data.split(",").map(&:to_i)
        else
          data = REXML::XPath.match(layer, "data/tile").map { |tile| tile.attributes["gid"].to_i }
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

      def to_boolean(text)
        ![ "false", "0" ].include?(text)
      end

      def map_tilesets(xml)
        REXML::XPath.match(xml, "map/tileset").map do |tileset|
          # Firstgid is usually set in the main file,
          # even if a tileset is read from a separate file.
          firstgid = tileset.attributes["firstgid"].to_i

          source = tileset.attributes["source"]
          if source && source.size > 0
            this_dir = @options[:filename] ? File.dirname(@options[:filename]) : "."
            tileset_path = File.join(this_dir, source.text)
            contents = File.read(tileset_path)
            results = REXML::Document.new(contents)
            tileset = REXML::XPath.first(results, "tileset")
          end

          image = REXML::XPath.first(tileset, "image")

          properties = {
            "firstgid"    => firstgid || tileset.attributes["firstgid"].to_i,
            "name"        => tileset.attributes["name"],
            "tilewidth"   => tileset.attributes["tilewidth"].to_i,
            "tileheight"  => tileset.attributes["tileheight"].to_i,
            "spacing"     => tileset.attributes["spacing"].to_i,
            "margin"      => tileset.attributes["margin"].to_i,
            "image"       => image.attributes["source"],
            "imageheight" => image.attributes["height"].to_i,
            "imagewidth"  => image.attributes["width"].to_i,
            # "imagetrans" is a color to treat as transparent, like "ff00ff" for magenta.
            "imagetrans"  => image.attributes["trans"],
            "tiles" => tileset_tiles(tileset),
            "properties"  => properties(xml)
          }
        end
      end

      def tileset_tiles(ts)
        REXML::XPath.match(ts, "tile").map do |tile|
          terrain_str = tile.attributes["terrain"]
          terrains = terrain_str.split(",",3).map { |s| s == "" ? nil : s.to_i }

          # Using image and properties like imageheight/imagetrans to match top level
          image = REXML::XPath.first(tile, "image")
          
          tile_info = {
            "id"          => tile.attributes["id"].to_i,
            "terrain"     => terrains,
            "probability" => tile.attributes["probability"].to_f,
            "image"       => image.attributes["source"],
            "imageheight" => image.attributes["height"].to_i,
            "imagewidth"  => image.attributes["width"].to_i,
            "imagetrans"  => image.attributes["trans"],
            "properties"  => properties(tile)
          }
        end
      end

      def map_object_groups(xml)
        REXML::XPath.match(xml, "map/objectgroup").map do |object_group|
          objects = REXML::XPath.match(object_group, "object").map do |object|
            properties = {
              "name"       => object.attributes["name"],
              "type"       => object.attributes["type"],
              "x"          => object.attributes["x"].to_i,
              "y"          => object.attributes["y"].to_i,
              "width"      => object.attributes["width"].to_i,
              "height"     => object.attributes["height"].to_i,
              "visible"    => to_boolean(object.attributes["visible"]),
              "properties" => properties(object)
            }

            properties.merge(object_shape(object))
          end

          {
            "name"    => object_group.attributes["name"],
            "width"   => object_group.attributes["width"].to_i,
            "height"  => object_group.attributes["height"].to_i,
            "opacity" => (object_group.attributes["opacity"] == "" ? 1.0 : object_group.attributes["opacity"].to_f),
            "objects" => objects
          }
        end
      end

      def object_shape(object)
        if not REXML::XPath.match(object, "ellipse").empty?
          { "shape" => "ellipse" }
        elsif not REXML::XPath.match(object, "polyline").empty?
          points = REXML::XPath.first(object, "polyline").attributes["points"].split(" ")
          { "shape" => "polyline", "points" => points }
        elsif not REXML::XPath.match(object, "polygon").empty?
          points = REXML::XPath.first(object, "polygon").attributes["points"].split(" ")
          { "shape" => "polygon", "points" => points }
        else
          x = object.attributes["x"].to_i
          y = object.attributes["y"].to_i
          width = object.attributes["width"].to_i
          height = object.attributes["height"].to_i
          { "shape" => "polygon", "points" => [ "#{x},#{y}", "#{x + width},#{y}", "#{x + width},#{y + height}", "#{x},#{y + height}" ] }
        end
      end

      def map_image_layers(xml)
        REXML::XPath.match(xml, "map/imagelayer").map do |image_layer|
          {
            "name"   => image_layer.attributes["name"],
            "width"  => image_layer.attributes["width"].to_i,
            "height" => image_layer.attributes["height"].to_i
          }

        end
      end

    end

  end

  Parsers.register :tmx, Parser::Tmx
end
