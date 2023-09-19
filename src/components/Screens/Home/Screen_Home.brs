sub init()
  label = m.top.FindNode("helloWorld")
  m.config = ParseJson(ReadAsciiFile("pkg:/config/config.json"))
  m.heroBanner = m.top.findNode("heroBanner")
  m.heroLoadingOverlay = m.top.findNode("heroLoadingOverlay")
  m.heroBanner.ObserveFieldScoped("heroReady", "heroReadyStatus")
  m.rowList = m.top.findNode("exampleRowList")
  m.rowList.ObserveFieldScoped("rowItemFocused","changeFocus")
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
  m.rowList.content = rowContentData
  m.rowList.setFocus(true)
  m.top.screenReady = true
end sub

sub changeFocus(obj)
  newFocus = obj.getData()
  row = newFocus[0]
  col = newFocus[1]
  contentData = m.top.rowContent[row].content[col]
  m.heroBanner.heroContent = contentData
end sub

sub heroReadyStatus(obj)
  status = obj.getData()
  if status
    m.heroLoadingOverlay.visible = false
  else
    m.heroLoadingOverlay.visible = true
  end if
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