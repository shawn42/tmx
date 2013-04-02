require 'ostruct'

require "tmx/version"
require "tmx/parsers/parsers"
require "tmx/map"

module Tmx
  extend self

  #
  # Load the specified TMX file and return a Map that was found.
  #
  # @param [String] filename the name fo the Tiled Map file.
  # @param [Hash] options
  #
  # @returns [Map] the map instance defined within the specified file
  #
  def load(filename,options={})
    options = default_options(filename).merge(options)
    parse contents(filename), options
  end

  #
  # Parse the the string contents of a TMX file.
  #
  # @returns [Map] the map instance defined within the string
  def parse(contents,options={})
    contents = parser(options).parse contents
    Map.new contents.merge(contents: contents)
  end

  private

  def format(filename)
    File.extname(filename)[1..-1]
  end

  def contents(filename)
    File.read(filename)
  end

  def default_options(filename)
    { format: format(filename) }
  end

  def parser(options)
    format = options[:format].to_sym
    parsers[format].new(options)
  end

  def parsers
    Parsers.parsers
  end

end