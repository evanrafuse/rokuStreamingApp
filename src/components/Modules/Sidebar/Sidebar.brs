sub init()
  m.sideBarIcons = m.top.findNode("sideBarIcons")
  m.searchIcon = m.top.findNode("searchIcon")
  m.heartIcon = m.top.findNode("heartIcon")
  m.settingsIcon = m.top.findNode("settingsIcon")
  m.buttonIndex = 0
end sub

sub showSideBar(obj)
  showSideBarFlag = obj.getData()
  if showSideBarFlag
    m.buttonIndex = 0
    m.searchIcon.blendColor = "0xFFFFFFFF"
    m.heartIcon.blendColor = "0x96969696"
    m.settingsIcon.blendColor = "0x96969696"
    m.searchIcon.setFocus(true)
  end if
end sub

sub navigateSideBar(key)
  if "down" = key
    if false = m.settingsIcon.hasFocus()
      m.sideBarIcons.getChild(m.buttonIndex).blendColor = "0x96969696"
      m.buttonIndex++
      nextIcon = m.sideBarIcons.getChild(m.buttonIndex)
      nextIcon.blendColor = "0xFFFFFFFF"
      nextIcon.setFocus(true)
    end if
  else if "up" = key
    if false = m.searchIcon.hasFocus()
      m.sideBarIcons.getChild(m.buttonIndex).blendColor = "0x96969696"
      m.buttonIndex--
      nextIcon = m.sideBarIcons.getChild(m.buttonIndex)
      nextIcon.blendColor = "0xFFFFFFFF"
      nextIcon.setFocus(true)
    end if
  end if
end sub

sub showScreen()
  m.top.focusSideBar = false
  if 0 = m.buttonIndex
    m.global.screenManager.callFunc("openScreen", {"index":"SearchScreen"})
  else if 1 = m.buttonIndex
    m.global.screenManager.callFunc("openScreen", {"index":"FavoritesScreen"})
    ? "Open Favorites Screen"
  else if 2 = m.buttonIndex
    m.global.screenManager.callFunc("openScreen", {"index":"SettingsScreen"})
    ? "Open Settings Screen"
  end if
end sub

function onKeyEvent(key, press) as Boolean
  handled = false
  if press
      if "right" = key or "back" = key
        m.top.focusSideBar = "false"
      else if "up" = key or "down" = key
        navigateSideBar(key)
      else if "OK" = key
        showScreen()
      end if
    handled = true
  end if
  return handled
end function