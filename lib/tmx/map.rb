require 'tmx/tile_set'
require 'tmx/layer'
require 'tmx/object_group'
require 'tmx/object'
require 'tmx/objects'
require 'tmx/image_layer'

module Tmx

  class Map < OpenStruct
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
      @image_layers ||= Array(contents['image_layers']).map {|layer| ImageLayer.new layer.merge(contents: layer) }
    end
  end
end