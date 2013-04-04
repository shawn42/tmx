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
        parsed_contents = Oj.load(contents)

        object_layers = parsed_contents["layers"].find_all do |layer|
          layer["type"] == "objectgroup"
        end

        parsed_contents["object_groups"] = object_layers

        object_layers.each do |object_layer|
          parse_object_layer(object_layer)
        end

        image_layers = parsed_contents["layers"].find_all do |layer|
          layer["type"] == "imagelayer"
        end

        parsed_contents["image_layers"] = image_layers

        parsed_contents["layers"].reject! {|layer| layer["type"] != "tilelayer" }

        parsed_contents

      end

      private

      def parse_object_layer(object_layer)
        object_layer["objects"].each do |object|

          if object["ellipse"]
            object["shape"] = "ellipse"
          elsif object["polyline"]
            object["shape"] = "polyline"
            object["points"] = object["polyline"].map {|h| "#{h["x"]},#{h["y"]}" }
          elsif object["polygon"]
            object["shape"] = "polygon"
            object["points"] = object["polygon"].map {|h| "#{h["x"]},#{h["y"]}" }
          else
            x = object["x"]
            y = object["y"]
            width = object["width"]
            height = object["height"]

            object["shape"] = "polygon"
            object["points"] = [ "#{x},#{y}", "#{x + width},#{y}", "#{x + width},#{y + height}", "#{x},#{y + height}" ]
          end
        end
      end


    end

  end

  Parsers.register :json, Parser::Json
end