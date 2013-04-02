require 'tmx/tile_set'
require 'tmx/layer'

module Tmx

  class Map < OpenStruct
    def layers
      @layers ||= Array(contents['layers']).map {|layer| Layer.new layer.merge(contents: layer) }
    end

    def tilesets
      @tilesets ||= Array(contents['tilesets']).map {|set| TileSet.new set.merge(contents: set) }
    end
  end
end