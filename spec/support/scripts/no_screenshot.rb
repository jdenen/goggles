require 'goggles'
require 'page-object'

class Search
  include PageObject

  text_field(:search_box, :id => "gbqfq")
end

page = Search.new(@watir)
page.search_box = "manta"
sleep 1
