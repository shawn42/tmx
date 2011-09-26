require 'chingu'
require 'tmx'
require 'opengl' # Chingu needs it for retrofy

class Float
  INFINITY = 1.0 / 0.0 unless const_defined? :INFINITY
end

class Box < Chingu::GameObject
  # "It's just a box."
  
  # (Chingu takes care of everything we need here (it's magic))
end

class Door < Chingu::GameObject
  # this ought to take you somewhere else
end

class Dude < Chingu::GameObject
	# maybe your player logic goes here
end

class MapState < Chingu::GameState
  has_trait :viewport
  
  def initialize map_name, *rest
    super *rest
    
    # load our map
    @map = TMX::Map.new $window, map_name,
      :on_object => method(:create_chingu_object)
    @banner = Gosu::Image.from_text $window,
      @map.properties[:display_name],
      'Helvetica', 24
    
    $window.caption = 'tmx demo - %s' % @map.properties[:display_name]
  end
  
  def create_chingu_object name, group, properties
    map = group.map
    obj_class = Kernel.const_get properties[:type] rescue nil
    
    # assert that the object is a valid type
    raise TypeError, "#{properties[:type]} is not a game object" \
      unless obj_class.is_a? Class \
      and    obj_class.ancestors.include? Chingu::BasicGameObject
    
    # load image
    image_name = properties[:image]
    image = case image_name
      when /^tid:(\d+)$/
        # a tile from the map's tile set
        map.tile_set[Integer($1)]
      when nil
        # default image
        Gosu::Image['default']
      else
        # image as named
        Gosu::Image[File.join 'data', image_name]
      end
    
    # convert TMX properties to what Chingu is expecting
    properties.merge! \
      :image    => image.retrofy,
      :x        => properties[:x] + properties[:width]  / 2,
      :y        => properties[:y] + properties[:height] / 2,
      :factor_x => properties[:width].to_f  / image.width,
      :factor_y => properties[:height].to_f / image.height,
      :zorder   => 1
    
    # create and return the game object
    obj_class.create properties
  end
  
  def update
    super
    # move the map opposite the mouse pointer, with lag
    viewport.x = 0.9 * viewport.x + 0.1 * ($window.mouse_x - $window.width  + @map.width  / 2)
    viewport.y = 0.9 * viewport.y + 0.1 * ($window.mouse_y - $window.height + @map.height / 2)
  end
  
  def draw
    super
    
    fill_gradient \
      :from   => @map.properties[:bg1],
      :to     => @map.properties[:bg2],
      :zorder => -Float::INFINITY
    
    # map is not a game object
    @map.draw -viewport.x, -viewport.y
    
    fill_gradient \
      :from   => @map.properties[:fg1],
      :to     => @map.properties[:fg2],
      :zorder => Float::INFINITY
    
    @banner.draw 8, 8, Float::INFINITY
  end
end

class MapWindow < Chingu::Window
  def initialize
    super 400, 200, false
    
    # global inputs for our demo
    self.input = { :escape => :close }
    
    # load that map
    push_game_state MapState.new('data/test.tmx')
  end
end

MapWindow.new.show
