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
    m.previousScreen = m.currentScreen
    if invalid = searchScreen
      searchScreen = m.scene.createChild("SearchScreen")
      m.screens.AddReplace(params.index, searchScreen)
    else
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

sub goBack(params)
  ? m.screens.count()
  screen = params.index
  if 3 > m.screens.count()
    ? "In IF"
    home = m.screens.Lookup("HomeScreen")
    home.callFunc("showScreen")
    ' ? "Current Screen: "
    m.screens.Lookup(m.navHistory.peek()).visible = false
    ' search = m.screens.Lookup("SearchScreen")
    ' search.visible = false
    ' home.visible = true
    ' home.showScreen = true
  end if
  ' ? m.currentScreen
  ' m.currentScreen.visible = false
  ' ? m.currentScreen
  ' ' m.currentScreen = m.screens.Lookup(m.navHistory.pop())
  ' m.navHistory.pop()
  ' m.currentScreen = m.screens.Lookup(m.navHistory.peek())
  ' index = m.navHistory.count()-2
  ' ? index
  ' indexString = m.navHistory[index]
  ' ? indexString
  ' m.previousScreen = m.screens.Lookup(indexString)
  ' ? m.previousScreen
  ' m.currentScreen.visible = true
end sub

sub hideScreen()
end sub

