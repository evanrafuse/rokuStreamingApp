sub init()
  m.scene = m.top.GetScene()
  m.screens = {}
  m.navHistory = []
  m.previousScreen = invalid
  m.currentScreen = invalid
end sub

sub goForward(params)
  if "HomeScreen" = params.index
    homeScreen = m.screens.Lookup(params.index)
    if invalid = homeScreen
      homeScreen = m.scene.createChild("HomeScreen")
      m.screens.AddReplace(params.index, homeScreen)
      homeScreen.ObserveFieldScoped("screenReady", "showScreen")
      homeScreen.rowContent = params.content
    else
      m.previousScreen = m.currentScreen
      m.previousScreen.visible = false
      homeScreen.findNode("exampleRowList").setFocus(true)
    end if
    m.currentScreen = homeScreen
    m.currentScreen.visible = true
  else if "SearchScreen" = params.index
    searchScreen = m.screens.Lookup(params.index)
    ' ? "currentScreen: "; m.currentScreen
    m.previousScreen = m.currentScreen
    if invalid = searchScreen
      ?"create search screen"
      searchScreen = m.scene.createChild("SearchScreen")
      m.screens.AddReplace(params.index, searchScreen)
    else
      ' ?"nagivate to search screen"
      searchScreen.visible = true
      searchScreen.FindNode("keyboard").setFocus(true)
    end if
    m.currentScreen = searchScreen
    m.previousScreen.visible = false
  end if
  m.navHistory.Push(params.index)
end sub

sub showScreen(obj)
  hideLoading = obj.getData()
  m.top.screenReady = hideLoading
end sub

sub goBack(obj)
  screen = obj.getData()
end sub

sub hideScreen()
end sub

