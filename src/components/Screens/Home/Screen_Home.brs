sub init()
  label = m.top.FindNode("helloWorld")
  m.rowlist = m.top.findNode("exampleRowList")
end sub

sub createRows()
  m.rowlist.content = m.top.rowContent
  m.rowlist.setFocus(true)
end sub

sub screenShow(params)
end sub

sub screenFocus(params)
end sub

function onKeyEvent(key, press) as Boolean
  handled = false
  if press
    ? key
    handled = true
  end if
  return handled
end function