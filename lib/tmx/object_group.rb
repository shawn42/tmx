module Tmx
  class ObjectGroup < OpenStruct

    def objects
      Array(contents['objects']).map {|object| Tmx::Object.new(object.merge(contents: object)) }
    end

    def find(params)
      objects.find_all do |object|
        params.any? {|key,value| object.send(key) == value }
      end.compact
    end

  end
end