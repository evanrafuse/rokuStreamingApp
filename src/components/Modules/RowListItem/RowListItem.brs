sub init()
  m.itemposter = m.top.findNode("itemPoster")
end sub

sub showcontent()
  itemcontent = m.top.itemContent
  m.itemposter.uri = itemcontent.HDPosterUrl
end sub