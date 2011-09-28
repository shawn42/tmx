
require File.join(File.dirname(__FILE__), 'spec_helper')
describe 'object groups' do
  
# {:image=>"door.png", :target=>"door2", :name=>"door1", :type=>"Door", :x=>128, :y=>208, :width=>16, :height=>32}
# {:image=>"door.png", :target=>"door1", :name=>"door2", :type=>"Door", :x=>64, :y=>32, :width=>16, :height=>32}

  it 'loads all object group properties' do
    map = Tmx::Map.new File.join($data_dir, 'test.tmx'), :scale_units => false
    object_group = map.object_groups["doors"]
    object_group.should_not be_nil

    captured = []
    object_group.each do |obj|
      captured << obj
    end

    obj = captured.first

    obj[:target].should == "door2"
    obj[:image].should == "door.png"
    obj[:type].should == "Door"
    obj[:x].should == 128
    obj[:y].should == 208
    obj[:width].should == 16
    obj[:height].should == 32
    obj[:name].should == "door1"

    obj = captured.last
    obj[:target].should == "door1"
    obj[:image].should == "door.png"
    obj[:type].should == "Door"
    obj[:x].should == 64
    obj[:y].should == 32
    obj[:width].should == 16
    obj[:height].should == 32
    obj[:name].should == "door2"
  end
  
  
end
