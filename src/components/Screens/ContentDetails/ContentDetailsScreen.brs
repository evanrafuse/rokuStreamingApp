sub init()
  m.config = m.global.config
  m.background = m.top.FindNode("background")
  m.movieLogo = m.top.FindNode("movieLogo")
  m.metaDataLabel = m.top.FindNode("metaDataLabel")
  m.taglineLabel = m.top.FindNode("taglineLabel")
  m.descriptionLabel = m.top.FindNode("descriptionLabel")
  m.playBtn = m.top.FindNode("playBtn")
  m.favoriteBtn = m.top.FindNode("favoriteBtn")
end sub

sub screenShow(params)
  m.top.previousScreen = params.previousScreen
  ' ? "Content: "; params.content
  m.content = params.content
  getLogo()
  getMovieDetails()
  m.background.uri = m.config.tmdbConfig.basePhotoUrl + "w500" + m.content.backdrop_path
  m.descriptionLabel.text = m.content.overview
  m.global.screenManager.screenReady = true
  m.top.visible = true
  m.playBtn.setFocus(true)
end sub

sub getLogo()
  key = "?api_key=" + m.config.api_keys.tmdbKey
  url = m.config.tmdbConfig.baseUrl + "movie/" + m.content.id.ToStr() + "/images" + key
  m.logoTask = createObject("roSGNode", "restTask")
  m.logoTask.observeField("response", "onLogoResponse")
  m.logoTask.request = {"url":url, "index":"heroLogo"}
  m.logoTask.control = "RUN"
end sub

sub onLogoResponse(obj)
  heroContent = obj.getData().content
  heroLogoUrl = ""
  for each logo in heroContent.logos
    if "en" = logo.iso_639_1
    heroLogoUrl = m.config.tmdbConfig.basePhotoUrl + "w500" + logo.file_path
      exit for
    end if
  end for
  m.movieLogo.uri = heroLogoUrl
  ' m.top.logoReady = true
end sub


sub getMovieDetails()
  key = "?api_key=" + m.config.api_keys.tmdbKey
  url = m.config.tmdbConfig.baseUrl + "movie/" + m.content.id.ToStr() + key
  m.movieDetailsTask = createObject("roSGNode", "restTask")
  m.movieDetailsTask.observeField("response", "onMovieDetailsResponse")
  m.movieDetailsTask.request = {"url":url, "index":"movieDetails"}
  m.movieDetailsTask.control = "RUN"
end sub

sub onMovieDetailsResponse(obj)
  movieDetails = obj.getData().content
  ?movieDetails
  m.taglineLabel.text = movieDetails.tagline
  runtime = movieDetails.runtime.ToStr() + " minutes"
  release = movieDetails.release_date

  genreText = ""
  for each genre in movieDetails.genres
    genreText = genreText + genre.name + ", "
  end for
  genreText = genreText.Left(genreText.Len()-2)

  m.metaDataLabel.text = genreText + " | " + runtime + " | " + release

end sub

function onKeyEvent(key, press) as Boolean
  handled = false
  if press
    if "left" = key
      m.playBtn.setFocus(true)
    else if "right" = key
      m.favoriteBtn.setFocus(true)
    else if "back" = key
      m.global.screenManager.callFunc("goBack", {"index":"ContentDetailsScreen", "previousScreen":m.top.previousScreen})
      handled = true
    end if
  end if
  return handled
end function
