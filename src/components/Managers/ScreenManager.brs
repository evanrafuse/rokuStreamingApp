sub init()
  m.scene = m.top.GetScene()
  m.screens = {}
end sub

sub openScreen(params)
  if "HomeScreen" = params.index
    homeScreen = m.screens.Lookup(params.index)
    if invalid = homeScreen
      homeScreen = m.scene.createChild("HomeScreen")
      m.screens.AddReplace(params.index, homeScreen)
      homeScreen.ObserveFieldScoped("screenReady", "showScreen")
      homeScreen.rowContent = params.content
    else
      homeScreen.callFunc("screenShow")
    end if
  else if "SearchScreen" = params.index
    m.screens.Lookup("HomeScreen").visible = false
    searchScreen = m.screens.Lookup(params.index)
    if invalid = searchScreen
      searchScreen = m.scene.createChild("SearchScreen")
      m.screens.AddReplace(params.index, searchScreen)
    end if
    searchScreen.callFunc("screenShow")
  end if
end sub

' Sends a Signal up to the Main Scene to hide the loading overlay on App Launch
sub showScreen(obj)
  hideLoading = obj.getData()
  m.top.screenReady = hideLoading
end sub

sub goBack(params)
  screen = m.screens.Lookup(params.index)
  previousScreen = m.screens.Lookup(params.previousScreen)
  previousScreen.callFunc("screenShow")
  screen.visible = false
end sub

sub hideScreen()
end sub

