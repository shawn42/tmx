require_relative 'tile_set'
require_relative 'layer'

module Tmxed

  class Map
    attr_reader :contents

    def initialize(contents)
      @contents = contents
    end

    def orientation
      contents['orientation']
    end

    def width
      contents['width'].to_i
    end

    def height
      contents['height'].to_i
    end

    def layers
      @layers ||= contents['layers'].map {|l| Layer.new l }
    end

    def tilewidth
      contents['tilewidth'].to_i
    end

    def tileheight
      contents['tileheight'].to_i
    end

    def version
      contents['version'].to_i
    end

    def properties
      contents['properties']
    end

    def tilesets
      @tilesets ||= Array(contents['tilesets']).map {|set| TileSet.new set }
    end

  end
end