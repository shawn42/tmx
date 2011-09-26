# TODO investigate writing Nokogiri::TMX class hierarchy (yeah right)

class Nokogiri::XML::Node
  def to_sym; self.to_s.to_sym end
  
  def to_i; self.to_s.to_i end
  def to_f; self.to_s.to_f end
  def to_c; self.to_s.to_c end
  def to_r; self.to_s.to_r end
  
  def tmx_parse
    str = to_s
    case str
    when ''                                            then nil
    when %r(^ (?: false | no  | off )             $)ix then false
    when %r(^ (?: true  | yes | on  )             $)ix then true
    when %r(^ [+-]?     \d+        / [+-]?  \d+   $)ix then str.to_r
    when %r(^ [+-]? (?: \d+ \. \d+   [+-] ) \d+ i $)ix then str.to_c
    when %r(^ [+-]?     \d+ \. \d+                $)ix then str.to_f
    when %r(^ [+-]?     \d+                       $)ix then str.to_i
    when %r(^ \# [0-9a-f]{6} $)ix
      0xff000000 | str[1..6].to_i(16)
    when %r(^ \# [0-9a-f]{8} $)ix
      str[1..8].to_i(16)
    else str
    end
  end
end

class Nokogiri::XML::Element
  def tmx_parse_attributes
    attributes.reduce({}) do |h, pair|
      name  = pair[0].to_sym
      value = pair[1].tmx_parse
      h.merge name => value
    end
  end
  
  def tmx_parse_properties
    properties_element = xpath('properties').first or return {}
    properties_element.xpath('property').reduce({}) do |h, property|
      name  = property.attribute('name').to_sym
      value = property.attribute('value').tmx_parse
      h.merge! name => value
    end
  end
  
  def tmx_data
    data = ''
    xpath('data').each do |data_element|
      attrs = data_element.tmx_parse_attributes
      data << Tmx::Coder.decode(data_element.text, attrs[:compression], attrs[:encoding])
    end
    data
  end
end
