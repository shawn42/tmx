module Tmxed
  class TileSet

    attr_reader :contents

    def initialize(contents)
      @contents = contents
    end

    def firstgid
      contents['firstgid']
    end

    def image_path
      contents['image']
    end

    def image(index)
      images.at(index)
    end

    def image_height
      contents['imageheight'].to_i
    end

    def image_width
      contents['imagewidth'].to_i
    end

    def margin
      contents['margin'].to_i
    end

    def name
      contents['name']
    end

    def spacing
      contents['spacing'].to_i
    end

    def tileheight
      contents['tileheight'].to_i
    end

    def tilewidth
      contents['tilewidth'].to_i
    end

    def properties
      contents['properties']
    end

  end
end