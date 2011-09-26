module Tmx
  class Layer
    attr_reader :properties
    attr_reader :columns, :rows
    
    def initialize map, data, properties
      @map        = WeakRef.new map
      @properties = properties.dup
      
      @columns = @properties.delete(:width)  or raise ArgumentError, "layer width is required"
      @rows    = @properties.delete(:height) or raise ArgumentError, "layer height is required"
            
      @tile_ids = case data
        when String then data.unpack('V*')
        when Array  then data.dup
        when nil    then Array.new @columns * @rows, 0
        else raise ArgumentError, "data must be a binary string or an array of integers"
        end
    end # initialize
    
    def map; @map.__getobj__ end
    
    def [] x, y
      raise IndexError unless x_range.include? x and y_range.include? y
      @tile_ids[offset(x, y)]
    end
    
    def []= x, y, id
      raise IndexError unless x_range.include? x and y_range.include? y
      @tile_ids[offset(x, y)] = id
    end
    
    def each_tile_id &block
      y_range.each do |y|
        x_range.each do |x|
          yield x, y, @tile_ids[offset(x, y)]
        end
      end
    end # each_tile_id
    
    def x_range; 0...@columns end
    def y_range; 0...@rows    end
    
    # def draw x_off, y_off, z_off, x_range, y_range
    #   x_range = [x_range.min, 0].max .. [x_range.max, @columns  - 1].min
    #   y_range = [y_range.min, 0].max .. [y_range.max, @rows     - 1].min
    #   
    #   tile_set    = @map.tile_set
    #   tile_width  = @map.tile_width
    #   tile_height = @map.tile_height
    #   
    #   y_range.each do |y|
    #     tile_y_off = y_off + y * tile_height
    #     
    #     x_range.each do |x|
    #       tile_x_off = x_off + x * tile_width
    #       tile_index = @tile_ids[offset(x, y)]
    #       
    #       image = tile_set[tile_index]
    #       next if image.nil?
    #       
    #       image.draw tile_x_off, tile_y_off, z_off, 1, 1, @color
    #     end
    #   end
    # end
    
    private
    
    def offset x, y
      x + y * @columns
    end
    
  end # Layer
end
