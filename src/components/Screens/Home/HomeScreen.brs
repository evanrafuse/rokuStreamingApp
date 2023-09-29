sub init()
  label = m.top.FindNode("helloWorld")
  m.config = ParseJson(ReadAsciiFile("pkg:/config/config.json"))
  m.heroBanner = m.top.findNode("heroBanner")
  m.heroLoadingOverlay = m.top.findNode("heroLoadingOverlay")
  m.heroBanner.ObserveFieldScoped("heroReady", "heroReadyStatus")
  m.rowList = m.top.findNode("exampleRowList")
  m.rowList.ObserveFieldScoped("rowItemFocused","changeFocus")
  m.sideBar = m.top.findNode("sideBar")
  m.sideBarAnim = m.top.findNode("sideBarAnim")
  m.sideBarSlideAnim = m.top.findNode("sideBarSlideAnim")
  m.sideBar.ObserveFieldScoped("focusSideBar","animateSideBar")
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
  m.top.showScreen = true
end sub

sub showScreen(obj)
  show = obj.getData()
  if show
    m.rowList.setFocus(true)
    m.sideBar.focusSideBar = false
    m.global.screenManager.screenReady = true
  end if
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

sub animateSideBar(obj)
  showing = obj.getData()
  if showing
    m.sideBarSlideAnim.keyValue = [[-200,0],[0,0]]
  else
    m.sideBarSlideAnim.keyValue = [[0,0],[-200,0]]
    m.rowList.setFocus(true)
  end if
  m.sideBarAnim.control = "start"
end sub

' sub screenShow(params)
' end sub

' sub screenFocus(params)
' end sub

function onKeyEvent(key, press) as Boolean
  handled = false
  if press
    if "left" = key or "options" = key
      m.sideBar.focusSideBar = true
    end if
    handled = true
  end if
  return handled
end function