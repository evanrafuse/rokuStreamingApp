sub init()
  m.scene = m.top.GetScene()
  m.screenStack = []
end sub

sub goForward(params)
  if 0 < m.screenStack.Count()
    previousScreen = m.screenStack.Peek()
  end if
  if "homeScreen" = params.index
    homeScreen = m.scene.createChild("homeScreen")
    m.screenStack.Push(homeScreen)
    homeScreen.ObserveFieldScoped("screenReady", "showScreen")
    homeScreen.rowContent = params.content
  else if "searchScreen" = params.index
    ?"Show Search Screen!"
    searchScreen = m.scene.createChild("SearchScreen")
    m.screenStack.Push(searchScreen)
    previousScreen.visible = false
  end if

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

