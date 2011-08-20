include Nanoc3::Helpers::Blogging
include Nanoc3::Helpers::Text

def pages
  @items.select { |item| item[:kind] != 'page' }
end
