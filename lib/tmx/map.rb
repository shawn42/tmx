require 'tmx/tile_set'
require 'tmx/layer'
require 'tmx/object_group'
require 'tmx/object'
require 'tmx/objects'
require 'tmx/image_layer'

module Tmx

  class Map < OpenStruct
    #
    # Export this map to the given filename in the appropriate format.
    #
    # @param filename [String] The file path to export to
    # @param options [Hash] Options for exporting
    # @option options [Symbol] format The format to export to, such as :tmx or :json
    # @return [void]
    #
    def export_to_file(filename, options={})
      content_string = export_to_string(default_options(filename).merge(:filename => filename))
      File.open(filename, "w") { |f| f.write(content_string) }
      nil
    end

    #
    # Export this map as a string in the appropriate format.
    #
    # @param options [Hash] Options for exporting
    # @option options [Symbol,String] :format The format to export to, such as :tmx or :json
    # @option options [String] :filename The eventual filename, which gives a relative path for linked TSX files
    # @return [String] The exported content in the appropriate format
    #
    def export_to_string(options = {})
      hash = self.to_h

      # Need to add back all non-tilelayers to hash["layers"]
      image_layers = hash.delete(:image_layers)
      object_groups = hash.delete(:object_groups)
      hash[:layers] += image_layers
      hash[:layers] += object_groups
      hash[:layers].sort_by! { |l| l[:name] }
      hash.delete(:contents)

      object_groups.each do |object_layer|
        object_layer["objects"].each do |object|
          # If present, "shape" and "points" should be removed
          object.delete("shape")
          object.delete("points")
        end
      end

      MultiJson.dump(hash)
    end

    private

    def format(filename)
      File.extname(filename)[1..-1]
    end

    def default_options(filename)
      { format: format(filename) }
    end

    def exporter(options)
      format = options[:format].to_sym
      exporters[format].new(options)
    end

    def exporters
      Exporters.exporters
    end

    public

    def layers
      @layers ||= Array(contents['layers']).map {|layer| Layer.new layer.merge(contents: layer) }
    end

    def tilesets
      @tilesets ||= Array(contents['tilesets']).map {|set| TileSet.new set.merge(contents: set) }
    end

    def object_groups
      @object_groups ||= Array(contents['object_groups']).map {|group| ObjectGroup.new group.merge(contents: group) }
    end

    # @return [Objects] an array-like object of all the objects within the map
    def objects
      Objects.new object_groups.map {|og| og.objects }.flatten
    end

    def image_layers
      @object_groups ||= Array(contents['image_layers']).map {|layer| ImageLayer.new layer.merge(contents: layer) }
    end
  end
end