sub init()
  m.keyboard = m.top.FindNode("keyboard")
  m.searchBtn = m.top.FindNode("searchBtn")
  m.searchBtn.ObserveFieldScoped("buttonSelected", "searchBtnInput")

  m.sideBar = m.top.findNode("sideBar")
  m.sideBarAnim = m.top.findNode("sideBarAnim")
  m.sideBarSlideAnim = m.top.findNode("sideBarSlideAnim")
  m.sideBar.ObserveFieldScoped("focusSideBar","animateSideBar")

  m.keyboard.setFocus(true)
end sub

sub animateSideBar(obj)
  showing = obj.getData()
  if showing
    m.sideBarSlideAnim.keyValue = [[-200,0],[0,0]]
  else
    m.sideBarSlideAnim.keyValue = [[0,0],[-200,0]]
    m.keyboard.setFocus(true)
  end if
  m.sideBarAnim.control = "start"
end sub

sub searchBtnInput(event)
  input = event.getData()
  ? "Search for: "; m.keyboard.text
end sub

function onKeyEvent(key, press) as Boolean
  handled = false
  if press
    ? "Search Screen Press: "; key
    if "down" = key
      if m.keyboard.isInFocusChain()
        m.searchBtn.setFocus(true)
      end if
    else if "up" = key
      if m.searchBtn.hasFocus()
        m.keyboard.setFocus(true)
      end if
    else if "options" = key or "left" = key
        ?"Show sidebar!! "
        m.sideBar.focusSideBar = true
    end if
  end if
  return handled
end function

' no search on release because of API limits. User has to click search button.
' results is a poster grid of the Posters the response returns

' "https://api.themoviedb.org/3/search/movie?include_adult=false&language=en-US&page=1" + APIKEY + "&query=" + QUERYHERE