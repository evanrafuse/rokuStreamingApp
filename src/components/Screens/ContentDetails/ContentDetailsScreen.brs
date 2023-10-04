sub init()
  m.config = ParseJson(ReadAsciiFile("pkg:/config/config.json"))
  m.sideBar = m.top.findNode("sideBar")
  m.sideBarAnim = m.top.findNode("sideBarAnim")
  m.sideBarSlideAnim = m.top.findNode("sideBarSlideAnim")
  m.sideBar.ObserveFieldScoped("focusSideBar","animateSideBar")
end sub

sub showScreen(obj)
  show = obj.getData()
  if show
    m.rowList.setFocus(true)
    m.sideBar.focusSideBar = false
    m.global.screenManager.screenReady = true
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