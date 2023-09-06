sub init()
  m.screenLoading = false
  m.screenLoaded = false

  m.restApi = m.global.restApiTask
  m.scene = m.top.getScene()
  m.lastFocus = Invalid
end sub


sub screenShow(params)
end sub


sub screenFocus(params)
end sub

sub screenHide(params)
end sub

sub screenKill(params)
end sub

function onKeyEvent(key, press) as Boolean
  if true = press
  end if

  return false
end function