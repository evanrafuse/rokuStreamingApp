sub init()
  m.homeIcon = m.top.findNode("homeIcon")
  m.sideBarIcons = m.top.findNode("sideBarIcons")
  m.homeIcon = m.top.findNode("homeIcon")
  m.searchIcon = m.top.findNode("searchIcon")
  m.heartIcon = m.top.findNode("heartIcon")
  m.settingsIcon = m.top.findNode("settingsIcon")
  m.buttonIndex = 0
end sub

sub showSideBar(obj)
  showSideBarFlag = obj.getData()
  if showSideBarFlag
    m.buttonIndex = 0
    m.searchIcon.blendColor = "0x96969696"
    m.heartIcon.blendColor = "0x96969696"
    m.settingsIcon.blendColor = "0x96969696"
    m.homeIcon.blendColor = "0xFFFFFFFF"
    m.homeIcon.setFocus(true)
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
    if false = m.homeIcon.hasFocus()
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
    m.global.screenManager.callFunc("goForward", {"index":"HomeScreen"})
  else if 1 = m.buttonIndex
    m.global.screenManager.callFunc("goForward", {"index":"SearchScreen"})
  else if 2 = m.buttonIndex
    ? "Open Favorites Screen"
  else if 3 = m.buttonIndex
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