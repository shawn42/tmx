# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "tmx/version"

Gem::Specification.new do |s|
  s.name        = "tmx"
  s.version     = Tmx::VERSION
  s.authors     = ["erisdiscord"]
  s.email       = ["eris.discord@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Eventually, a usable TMX map loader that works with Gosu and doesn't care whether you're using Chingu or some home-grown game engine of your own devising.}
  s.description = %q{Eventually, a usable TMX map loader that works with Gosu and doesn't care whether you're using Chingu or some home-grown game engine of your own devising.}

  s.rubyforge_project = "tmx"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]


  s.add_development_dependency "rake"
  s.add_development_dependency "rspec"
  s.add_development_dependency "gosu"

  s.add_runtime_dependency "nokogiri"
end
