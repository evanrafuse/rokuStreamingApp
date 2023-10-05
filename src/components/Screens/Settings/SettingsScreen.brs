sub init()
  ? "Settings Screen Init"
  m.placeholder = m.top.FindNode("placeholder")
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
      m.global.screenManager.callFunc("goBack", {"index":"SettingsScreen", "previousScreen":"HomeScreen"})
      handled = true
    end if
  end if
  return handled
end function
