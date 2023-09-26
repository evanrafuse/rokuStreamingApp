sub init()
  m.scene = m.top.GetScene()
end sub

sub goForward(params)
  if "homeScreen" = params.index
    screenHome = m.scene.createChild("ScreenHome")
    m.top.screenStack.Push(screenHome)
    screenHome.ObserveFieldScoped("screenReady", "showScreen")
    screenHome.rowContent = params.content
  else if "searchScreen" = params.index
    ?"Show Search Screen!"
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

