# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tmxed/version'

Gem::Specification.new do |gem|
  gem.name          = "tmxed"
  gem.version       = Tmxed::VERSION
  gem.authors       = ["Franklin Webber"]
  gem.email         = ["franklin.webber@gmail.com"]
  gem.description   = %q{Processes Tile Editor TMX files}
  gem.summary       = %q{Processes Tile Editor TMX files}
  gem.homepage      = ""
  gem.license       = "MIT"
  
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
