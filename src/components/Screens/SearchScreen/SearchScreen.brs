sub init()
end sub

function onKeyEvent(key, press) as Boolean
  handled = false
  if press
    ? "Search Screen Press"
  end if
  return handled
end function

' screen should have keyboard on one side.
' no search on release because of API limits. User has to click search button.
' screen is split 50/50 with keyboard on left, results on right
' results is a poster grid of the Posters the response returns

' "https://api.themoviedb.org/3/search/movie?include_adult=false&language=en-US&page=1" + APIKEY + "&query=" + QUERYHERE