sub init()
  m.optionsButtons = m.top.FindNode("optionsBtns")
  m.optionsButtons.buttons = ["Categories", "Clear Favorites", "Clear Search History", "Log Out"]
  m.optionsButtons.ObserveFieldScoped("buttonSelected", "onOptionSelected")
  m.config = m.global.config
  ' m.catIDs = ParseJson(ReadAsciiFile("pkg:/config/categoryIds.json"))
  m.categoryList = m.top.FindNode("categoryList")
  m.categoryContent = m.top.FindNode("categoryContent")

end sub

sub screenShow()
  m.global.screenManager.screenReady = true
  m.top.visible = true
  m.optionsButtons.setFocus(true)
end sub

sub showCategories()
  categories = [{"title":"Action", "state":true}, {"title":"Adventure", "state":false}, {"title":"Animation", "state":false}, {"title":"Comedy", "state":false}, {"title":"Drama", "state":true}]
  checkStates = []
  for each category in categories
    ? category.title
    categoryName = createObject("roSGNode","ContentNode")
    categoryName.title = category.title
    m.categoryContent.appendChild(categoryName)
    checkStates.Push(category.state)
  end for
  m.categoryList.appendChild(m.categoryContent)
  m.categoryList.checkedState = checkStates
  m.categoryList.visible = true
end sub

sub showClearFavoritesDialog()
  m.clearFavoritesDialog = createObject("roSGNode", "Dialog")
  m.clearFavoritesDialog.backgroundUri = "pkg:/assets/images/dialogBackground.9.png"
  m.clearFavoritesDialog.title = "Clear Favorites"
  m.clearFavoritesDialog.message = "Would you like to clear favorited shows?"
  m.clearFavoritesDialog.buttons = ["OK","Cancel"]
  m.clearFavoritesDialog.ObserveFieldScoped("buttonSelected", "clearFavoritesButtonSelected")
  scene = m.top.GetScene()
  scene.dialog = m.clearFavoritesDialog
end sub

sub clearFavoritesButtonSelected(event)
  btnIndex = event.getData()
  m.clearFavoritesDialog.close = true
  if 0 = btnIndex
    ? "Clear Favorites!"
  else
    ? "Cancel Clear Favorites!"
  end if
end sub

sub showClearSearchDialog()
  m.clearSearchDialog = createObject("roSGNode", "Dialog")
  m.clearSearchDialog.backgroundUri = "pkg:/assets/images/dialogBackground.9.png"
  m.clearSearchDialog.title = "Clear Search History"
  m.clearSearchDialog.message = "Would you like to clear search history?"
  m.clearSearchDialog.buttons = ["OK","Cancel"]
  m.clearSearchDialog.ObserveFieldScoped("buttonSelected", "clearSearchButtonSelected")
  scene = m.top.GetScene()
  scene.dialog = m.clearSearchDialog
end sub

sub clearSearchButtonSelected(event)
  btnIndex = event.getData()
  m.clearSearchDialog.close = true
  if 0 = btnIndex
    ? "Clear Search History!"
  else
    ? "Cancel Clear Search History!"
  end if
end sub

sub showLogoutDialog()
  m.logoutDialog = createObject("roSGNode", "Dialog")
  m.logoutDialog.backgroundUri = "pkg:/assets/images/dialogBackground.9.png"
  m.logoutDialog.title = "Logout"
  m.logoutDialog.message = "Would you like to log out?"
  m.logoutDialog.buttons = ["OK","Cancel"]
  m.logoutDialog.ObserveFieldScoped("buttonSelected", "logoutButtonSelected")
  scene = m.top.GetScene()
  scene.dialog = m.logoutDialog
end sub

sub logoutButtonSelected(event)
  btnIndex = event.getData()
  m.logoutDialog.close = true
  if 0 = btnIndex
    ? "Logout of Channel!"
  else
    ? "Cancel Logout!"
  end if
end sub

sub onOptionSelected(obj)
  selection = obj.getData()
  if 0 = selection
    ? "Categories selected!"
    showCategories()
  else if 1 = selection
    ? "Clear Favorites selected!"
    showClearFavoritesDialog()
  else if 2 = selection
    ? "Clear Search History selected!"
    showClearSearchDialog()
  else if 3 = selection
    ? "Log Out selected!"
    showLogoutDialog()
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
