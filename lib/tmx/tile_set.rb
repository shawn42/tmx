module Tmx
  # class TileSet
  #   def initialize map
  #     @map   = WeakRef.new map
  #     @tiles = [ nil ]
  #   end
  #   
  #   def load_tiles file_name_or_images, properties = {}
  #     properties  = properties.dup
  #     first_id    = properties.delete :firstgid
  #     tile_width  = properties.delete :tilewidth
  #     tile_height = properties.delete :tileheight
  #     
  #     @tiles[first_id..-1] = case file_name_or_images
  #       when String then Gosu::Image.load_tiles(@map.window, file_name_or_images, tile_width, tile_height, true).freeze
  #       when Array  then file_name_or_images.dup
  #       else raise ArgumentError, "must supply a file name or an array of images"
  #       end
  #     
  #   end # load_tiles
  #   
  #   def map; @map.__getobj__ end
  #   
  #   def [] tile_id
  #     raise IndexError unless (0...@tiles.length).include? tile_id
  #     @tiles[tile_id]
  #   end
  #   
  #   def []= tile_id, image
  #     raise IndexError unless (1...@tiles.length).include? tile_id
  #     @tiles[tile_id] = image
  #   end
  #   
  # end
end
