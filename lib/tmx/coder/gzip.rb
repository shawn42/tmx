module Tmx
  module Coder
    module Gzip
      def self.encode str
        buffer = String.new
        writer = Zlib::GzipWriter.new(StringIO.new(buffer))
        writer << str
        writer.close
        buffer
      end
      
      def self.decode str
        reader = Zlib::GzipReader.new(StringIO.new(str))
        output = reader.read
        reader.close
        output
      end
      
    end # Gzip
  end
end
