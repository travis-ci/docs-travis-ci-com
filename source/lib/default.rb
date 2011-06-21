include Nanoc3::Helpers::Blogging

def pages
  @items.select { |item| item[:kind] != 'page' }
end
