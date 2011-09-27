autoload :Base64,   'base64'
autoload :Nokogiri, 'nokogiri'
autoload :WeakRef,  'weakref'
# autoload :Zlib,     'zlib'

# mysterious autoload failure
require 'zlib'

require 'tmx/nokogiri_additions'

module Tmx
  autoload :Coder,       'tmx/coder'
  autoload :Layer,       'tmx/layer'
  autoload :Map,         'tmx/map'
  autoload :ObjectGroup, 'tmx/object_group'
end
