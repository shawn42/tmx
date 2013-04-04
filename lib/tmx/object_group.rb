module Tmx
  class ObjectGroup < OpenStruct

    def objects
      Array(contents['objects']).map {|object| Tmx::Object.new(object.merge(contents: object)) }
    end

  end
end