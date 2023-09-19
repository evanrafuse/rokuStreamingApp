sub init()
  m.config = ParseJson(ReadAsciiFile("pkg:/config/config.json"))
  m.top.layoutDirection = "horiz"
  m.moviePoster = m.top.findNode("moviePoster")
  m.heroDetails = m.top.findNode("heroDetails")
end sub

sub updateHero(obj)
  content = obj.getData()
  m.heroDetails.heroDetailsContent = content
  moviePoster = m.config.tmdbConfig.basePhotoUrl + "w500" + content.backdrop_path
  m.moviePoster.uri = moviePoster
end sub

function onKeyEvent(key, press) as Boolean
  handled = false
  if press
    ? key
    handled = true
  end if
  return handled
end function