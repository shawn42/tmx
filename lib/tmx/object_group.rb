module Tmx
  class ObjectGroup
    include Enumerable
    
    attr_reader :properties
    attr_reader :name
    
    def initialize map, properties = {}
      @map        = WeakRef.new map
      @properties = properties
      @objects    = Hash[]
      
      @name = properties.delete :name
    end
    
    def map; @map.__getobj__ end
    
    def add obj
      @objects[obj.object_id] = obj
    end
    
    def remove obj
      @objects.delete obj.object_id
    end
    
    def each &block
      @objects.each_value &block
    end
  end
end
