sub init()
  m.optionsButtons = m.top.FindNode("optionsBtns")
  m.optionsButtons.buttons = ["Categories", "Clear Favorites", "Clear Search History", "Log Out"]
  m.optionsButtons.ObserveFieldScoped("buttonSelected", "onOptionSelected")
  m.config = m.global.config
  ' m.catIDs = ParseJson(ReadAsciiFile("pkg:/config/categoryIds.json"))

  m.categoryList = m.top.FindNode("categoryList")
  categories = ["Action", "Adventure", "Animation", "Comedy", "Drama"]
  m.categoryContent = createObject("roSGNode","ContentNode")
  for each category in categories
    ? category
    categoryName = createObject("roSGNode","ContentNode")
    categoryName.title = category
    m.categoryContent.appendChild(categoryName)
  end for
  m.categoryList.appendChild(m.categoryContent)

end sub

sub screenShow()
  m.global.screenManager.screenReady = true
  m.top.visible = true
  m.optionsButtons.setFocus(true)
end sub

sub onOptionSelected(obj)
  ? "TEST"
  ? "TEST"
  ? "TEST"
  selection = obj.getData()
  if 1 = selection
    ? "Categories selected!"
    ? ""
  else if 2 = selection
    ? "Clear Favorites selected!"
  else if 3 = selection
    ? "Clear Search History selected!"
  else if 4 = selection
    ? "Log Out selected!"
  end if
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
