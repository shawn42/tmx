module Tmx
  module Coder
    # default coders
    autoload :Base64, 'tmx/coder/base64'
    autoload :Gzip,   'tmx/coder/gzip'
    
    def self.encode str, *encodings
      encodings.reject(&:nil?).reduce(str) do |data, encoding|
        find_coder(encoding).encode(data)
      end
    end # encode
    
    def self.decode str, *encodings
      encodings.reject(&:nil?).reverse.reduce(str) do |data, encoding|
        find_coder(encoding).decode(data)
      end
    end # decode
    
    def self.find_coder name
      const_name = name.to_s.capitalize.gsub /(?:\b|_)([a-z])/, &:upcase
      if const_defined? const_name
        const_get const_name
      else
        raise NameError, "unknown coder #{name}"
      end
    end # find_coder
    
    def self.register_coder name, mod
      const_name = name.to_s.capitalize.gsub /(?:\b|_)([a-z])/, &:upcase
      if not const_defined? const_name
        const_set const_name, mod
      else
        raise NameError, "coder #{name} already registered"
      end
    end # register_coder
    
  end # Coder
  
end

module Zlib
  def self.decode(data)
    Deflate::deflate data
  end
end
