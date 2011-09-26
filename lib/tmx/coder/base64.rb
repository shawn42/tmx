module Tmx
  module Coder
    module Base64
      def self.encode str
        ::Base64.strict_encode64 str
      end
      
      def self.decode str
        ::Base64.decode64 str
      end
    end # Base64
  end
end
