
tmx_root = File.dirname(File.dirname(__FILE__))

$:.unshift File.join(tmx_root, 'lib')
$data_dir = File.join(tmx_root, 'data')

require 'gosu'
require 'tmx'

class TMXSpecWindow < Gosu::Window
  def initialize
    super 400, 200, false
  end
  
  def run_test options = {}
    @before = options.delete :before
    @update = options.delete :update
    @draw   = options.delete :draw
    @after  = options.delete :after
    
    @time_limit = options.delete(:time) || 1.0
    @start_time = Gosu.milliseconds / 1000.0
    
    @before.call if @before
    
    show
  end
  
  def end_test
    @after.call if @after
    close
  end
  
  def update
    this_time = Gosu.milliseconds / 1000.0
    @start_time
    
    @update.call(Gosu.milliseconds) if @update
    
    if this_time - @start_time > @time_limit
      end_test
    end
    
    @last_time = this_time
  end
  
  def draw
    @draw.call(Gosu.milliseconds) if @draw
  end
end

$window = TMXSpecWindow.new
