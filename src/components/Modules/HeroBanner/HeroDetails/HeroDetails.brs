sub init()
  m.top.layoutDirection = "vert"
  m.top.horizAlignment = "center"
  m.top.itemSpacings = [25]
  m.config = m.global.config
  m.movieLogo = m.top.findNode("movieLogo")
  m.genreLbl = m.top.findNode("genreLabel")
  m.dateLbl = m.top.findNode("dateLabel")
  m.descLbl = m.top.findNode("descriptionLabel")
end sub

sub updateHeroDetails(obj)
  m.top.logoReady = false
  content = obj.getData()
  getHeroLogo(content.id)
  m.descLbl.text = content.overview
end sub

sub getHeroLogo(id)
  key = "?api_key=" + m.config.api_keys.tmdbKey
  url = m.config.tmdbConfig.baseUrl + "movie/" + id.ToStr() + "/images" + key
  m.heroLogoTask = createObject("roSGNode", "restTask")
  m.heroLogoTask.observeField("response", "onHeroLogoResponse")
  m.heroLogoTask.request = {"url":url, "index":"heroLogo"}
  m.heroLogoTask.control = "RUN"
end sub

sub onHeroLogoResponse(obj)
  heroContent = obj.getData().content
  heroLogoUrl = ""
  for each logo in heroContent.logos
    if "en" = logo.iso_639_1
    heroLogoUrl = m.config.tmdbConfig.basePhotoUrl + "w500" + logo.file_path
      exit for
    end if
  end for
  m.movieLogo.uri = heroLogoUrl
  m.top.logoReady = true
end sub

function onKeyEvent(key, press) as Boolean
  handled = false
  if press
    ? key
    handled = true
  end if
  return handled
end function