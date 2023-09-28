sub init()
  m.keyboard = m.top.FindNode("keyboard")
  m.searchBtn = m.top.FindNode("searchBtn")
  m.searchBtn.ObserveFieldScoped("buttonSelected", "searchBtnInput")
  m.keyboard.setFocus(true)
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
      ' use has focus to check if the group is focused
      ' write logic for navigation down here
    end if
  end if
  return handled
end function

' no search on release because of API limits. User has to click search button.
' results is a poster grid of the Posters the response returns

' "https://api.themoviedb.org/3/search/movie?include_adult=false&language=en-US&page=1" + APIKEY + "&query=" + QUERYHERE