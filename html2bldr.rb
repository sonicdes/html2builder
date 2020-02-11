require 'oga'

def parse_block(element, indent=0)
  if element.is_a? Oga::XML::Text
    return '' if element.text.strip.empty?
    return " "*indent + "'#{element.text.strip}' \n"
  end

  return element.children.map {|ch| parse_block ch} if element.is_a? Oga::XML::Document

  attrs = element.attributes.map {|attr| "'#{attr.name}' => '#{attr.value}'"}.join(", ")
  pre = " "*indent + [element.name, attrs].join(" ") + " do\n"
  post = " "*indent + "end\n"
  inner_block = element.children.map {|ch| parse_block(ch, indent+2)}
  return [pre, inner_block, post].join
end

doc = Oga.parse_html(File.read(ARGV[0]))
puts parse_block(doc)
