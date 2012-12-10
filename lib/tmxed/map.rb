require_relative 'tile_set'
require_relative 'layer'

module Tmxed

  class Map < OpenStruct
    def layers
      @layers ||= Array(contents['layers']).map {|layer| Layer.new layer.merge(contents: layer) }
    end

    def tilesets
      @tilesets ||= Array(contents['tilesets']).map {|set| TileSet.new set.merge(contents: set) }
    end
  end
end