sub init()
  ? "Favorites Screen Init"
  m.placeholder = m.top.FindNode("placeholder")
  m.config = m.global.config
end sub

sub screenShow()
  m.global.screenManager.screenReady = true
  m.top.visible = true
  m.placeholder.setFocus(true)
end sub

function onKeyEvent(key, press) as Boolean
  handled = false
  if press
    if "back" = key
      ? "Go Back!"
      m.global.screenManager.callFunc("goBack", {"index":"FavoritesScreen", "previousScreen":"HomeScreen"})
      handled = true
    end if
  end if
  return handled
end function
