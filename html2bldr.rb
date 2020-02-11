require 'oga'

def parse_block(element, indent=0)
  case element
  when Oga::XML::Text
    return '' if element.text.strip.empty?
    return " "*indent + "'#{element.text.strip.gsub("'"){"\\'"}}' \n"
  when Oga::XML::Document
    return element.children.map {|ch| parse_block ch}
  when Oga::XML::Comment
    return " "*indent + "\# #{element.text.strip}\n"
  when Oga::XML::Element
    attrs = element.attributes.map {|attr| "'#{attr.name}' => '#{attr.value}'"}.join(", ")
    pre = " "*indent + [element.name, attrs].join(" ") + " do\n"
    post = " "*indent + "end\n"
    inner_block = element.children.map {|ch| parse_block(ch, indent+2)}
    return [pre, inner_block, post].join
  end
end

doc = Oga.parse_html(File.read(ARGV[0]))
puts parse_block(doc)
