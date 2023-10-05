sub init()
  m.config = m.global.config
  m.top.layoutDirection = "horiz"
  m.moviePoster = m.top.findNode("moviePoster")
  m.heroDetails = m.top.findNode("heroDetails")
  m.heroDetails.ObserveFieldScoped("logoReady", "updateLoadingStatus")
end sub

sub updateHero(obj)
  m.top.heroReady = false
  content = obj.getData()
  m.heroDetails.heroDetailsContent = content
  moviePoster = m.config.tmdbConfig.basePhotoUrl + "w500" + content.backdrop_path
  m.moviePoster.uri = moviePoster
end sub

sub updateLoadingStatus(obj)
  status = obj.getData()
  m.top.heroReady = status
end sub

function onKeyEvent(key, press) as Boolean
  handled = false
  if press
    ? key
    handled = true
  end if
  return handled
end function