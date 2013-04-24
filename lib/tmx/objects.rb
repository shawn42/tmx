module Tmx

  #
  # Objects is a thin wrapper around an array of Object.
  #
  class Objects < Array

    #
    # Allows finding by type or a specfied hash of parameters
    #
    # @example Find all objects that have the type 'ground'
    #
    #     objects.find(:floor)
    #     objects.find(type: 'floor')
    #
    # @example Find all objects that have the name 'mushroom'
    #
    #     objects.find(name: "mushroom")
    #
    def find(params)
      params = { type: params } if params.is_a?(String)

      found_objects = find_all do |object|
        params.any? {|key,value| object.send(key) == value.to_s }
      end.compact

      self.class.new found_objects
    end

  end
end