require "tmxed/version"
require "tmxed/parsers/parsers"
require "tmxed/map"

module Tmxed
  extend self

  #
  # Parse the specified TMX file and return a Map that was found.
  #
  def parse(filename,options={})
    options[:format] = File.extname(filename)[1..-1] unless options[:format]
    file_contents = File.read(filename)
    contents = parser(options).parse(file_contents)
    Map.new contents
  end

  private

  def parser(options)
    format = options[:format].to_sym
    parsers[format].new(options)
  end

  def parsers
    Parsers.parsers
  end

end