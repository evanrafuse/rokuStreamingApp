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
  m.homeIcon.blendColor = "0xFFFFFFFF"
  m.homeIcon.setFocus(true)
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
  ? "Show Screen!"
  ' Call screen manager here?
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