sub init()
  label = m.top.FindNode("helloWorld")
  m.heroBanner = m.top.findNode("heroBanner")
  m.rowlist = m.top.findNode("exampleRowList")
end sub

sub createHero()
  ' This feels dumb
  m.heroBanner.heroContent = m.top.heroContent
end sub

sub createRows()
  rowContentData = CreateObject("roSGNode", "ContentNode")
  for each row in m.top.rowContent
    contentData = rowContentData.CreateChild("ContentNode")
    contentData.title = row.index
    for each show in row.content
      newShow = contentData.CreateChild("ContentNode")
      newShow.title = show.title
      posterUrl = "https://image.tmdb.org/t/p/w200" + show.poster_path
      newShow.HDPosterUrl = posterUrl
    end for
  end for
  m.rowlist.content = rowContentData
  m.rowlist.setFocus(true)
end sub

sub screenShow(params)
end sub

sub screenFocus(params)
end sub

function onKeyEvent(key, press) as Boolean
  handled = false
  if press
    ? key
    handled = true
  end if
  return handled
end function