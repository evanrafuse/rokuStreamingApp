sub init()
  m.useFallbacks = true
  ' m.useFallbacks = false
  m.rowContent = []
  m.heroContent = []
  getConfig()
end sub

sub getConfig()
  m.config = ParseJson(ReadAsciiFile("pkg:/config/config.json"))
  m.catIDs = ParseJson(ReadAsciiFile("pkg:/config/categoryIds.json"))
  if m.useFallbacks
    getHeroFallback()
    getRowFallback()
    createHome()
  else
    getHeroContent()
    for each category in m.config.tmdbConfig.defaultGenres.movie
      params = {"index":category, "rowType":"genre"}
      getRowContent(params)
    end for
    ' Can add Top Rated or other static categories here
    ' getRowContent({"index":"Top Rated", "rowType":"top"})
  end if
end sub

sub getHeroContent()
  m.top.apiCalls++
  urlPath = m.config.tmdbConfig.urlPath.popular
  key = "?api_key=" + m.config.api_keys.tmdbKey
  rating = m.config.tmdbConfig.rating
  lang = m.config.tmdbConfig.language
  url = m.config.tmdbConfig.baseUrl + urlPath + key + rating + lang
  m.contentTask = createObject("roSGNode", "restTask")
  m.contentTask.observeField("response", "onHeroContentResponse")
  m.contentTask.request = {"url":url, "index":"heroBanner"}
  ? "getHeroContent at: "; url
  m.contentTask.control = "RUN"
end sub

sub onHeroContentResponse(obj)
  heroContentResponse = obj.getData().content.results 'Results is here because some responses have it and some don't. Annoying.
  index = 0
  maxSlides = m.config.tmdbConfig.heroSlides
  for each movie in heroContentResponse
    index++
    m.heroContent.push(movie)
    m.top.apiCalls++
    url = m.config.tmdbConfig.baseUrl+"movie/"+movie.id+"/images"
    m.contentTask = createObject("roSGNode", "restTask")
    m.contentTask.observeField("response", "onRowContentResponse")
    m.contentTask.request = {"url":url, "index":movie.id}
    ? "getHeroLogoContent at: "; url
    m.contentTask.control = "RUN"
    if maxSlides = index
      exit for
    end if
  end for
end sub

sub onHeroLogoResponse(obj)
  m.top.apiCalls--
  response = obj.getData()
  logo = response.logos[0].file_path 'first one is fine
  id = response.id

  index = 0
  for each movie in m.heroContent
     if id = movie.id
      m.heroContent[index].AddReplace("logo", logo)
      exit for
     end if
     index++
  end for

  if 0 = m.top.apiCalls
    createHome()
  end if
end sub

sub getHeroFallback()
  featuredContent = ParseJson(ReadAsciiFile("pkg:/config/fallback/featured_movie_fallback.json")).results
  m.heroContent = featuredContent
end sub

sub getRowContent(params)
  m.top.apiCalls++
  urlPath = m.config.tmdbConfig.urlPath[params.rowType]
  key = "?api_key=" + m.config.api_keys.tmdbKey
  rating = m.config.tmdbConfig.rating
  lang = m.config.tmdbConfig.language
  url = m.config.tmdbConfig.baseUrl + urlPath + key + rating + lang
  if "genre" = params.rowType
    url = url + "&with_genres=" + m.catIDs[params.index]
  end if
  m.contentTask = createObject("roSGNode", "restTask")
  m.contentTask.observeField("response", "onRowContentResponse")
  m.contentTask.request = {"url":url, "index":params.index}
  ? "getRowContent at: "; url
  m.contentTask.control = "RUN"
end sub

sub onRowContentResponse(obj)
  m.top.apiCalls--
  rowData = obj.getData().results
  m.rowContent.push(rowData)
  if 0 = m.top.apiCalls
    createHome()
  end if
end sub

sub getRowFallback()
  actionContent = {"index":"Action", "content":ParseJson(ReadAsciiFile("pkg:/config/fallback/action_movie_fallback.json")).results}
  comedyContent = {"index":"Comedy", "content":ParseJson(ReadAsciiFile("pkg:/config/fallback/comedy_movie_fallback.json")).results}
  dramaContent = {"index":"Drama", "content":ParseJson(ReadAsciiFile("pkg:/config/fallback/drama_movie_fallback.json")).results}
  ' ratedContent = {"index":"Top Rated", "content":ParseJson(ReadAsciiFile("pkg:/config/fallback/highest_rated_movie_fallback.json")).results}
  m.rowContent = [actionContent, comedyContent, dramaContent]
end sub

sub createHome()
  screen_home = m.top.createChild("Screen_Home")
  screen_home.rowContent = m.rowContent
  screen_home.heroContent = m.heroContent
  ' should probably set screenReady for screen_home here and hide splash
end sub
