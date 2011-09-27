require File.join(File.dirname(__FILE__), 'spec_helper')
describe 'Map' do
  it 'can load the test map' do
    $map = Tmx::Map.new File.join($data_dir, 'test.tmx'),
      :scale_units => false
    $map.should.is_a? Tmx::Map
  end
  
  it 'has the correct dimensions' do
    $map.columns.should == 16
    $map.rows.should    == 16
    
    $map.width.should  == 16 * $map.tile_width
    $map.height.should == 16 * $map.tile_height
  end
  
  it 'has the correct tile dimensions' do
    $map.tile_width.should  == 16
    $map.tile_height.should == 16
  end
  
  # it 'loads all tile set definitions into one flat set' do
  #   $map.tile_set.should.is_a? Tmx::TileSet
  #   $map.tile_set[0].should == nil
  #   $map.tile_set[1].should.is_a? Gosu::Image
  # end
  
  it 'loads all layers' do
    $map.layers.count.should == 3
    $map.layers.each do |name, layer|
      layer.should.is_a? Tmx::Layer
    end
  end
  
  it 'loads all object groups' do
    $map.object_groups.count.should == 2
    $map.object_groups.each do |name, group|
      Tmx::ObjectGroup.should === group
    end
  end
  
  # it 'can draw itself' do
  #   $window.run_test\
  #     :time   => 1.0,
  #     :before => proc { @x, @y = 0, 0 },
  #     :update => proc { @y -= 1 },
  #     :draw   => proc { $map.draw @x, @y },
  # end
  
end
