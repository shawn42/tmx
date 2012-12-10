module Tmxed
  class Layer

    attr_reader :contents

    def initialize(contents)
      @contents = contents
    end

    def data
      contents['data']
    end

    def height
      contents['height'].to_i
    end

    def name
      contents['name']
    end

    def opacity
      contents['opacity'].to_f
    end

    def type
      contents['tilelayer']
    end

    def visible
      contents['visible']
    end

    def width
      contents['width'].to_i
    end

    def x
      contents['x'].to_i
    end

    def y
      contents['y'].to_i
    end
  end
end