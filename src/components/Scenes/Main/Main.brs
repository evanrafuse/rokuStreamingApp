sub init()
  m.top.backgroundColor = "0x000000FF"
  m.top.backgroundURI = ""
  ' m.useFallbacks = true
  m.useFallbacks = false
  m.rowContent = []
  getConfig()
end sub

sub getConfig()
  m.config = ParseJson(ReadAsciiFile("pkg:/config/config.json"))
  m.catIDs = ParseJson(ReadAsciiFile("pkg:/config/categoryIds.json"))
  if m.useFallbacks
    getRowFallback()
    createHome()
  else
    ' Featured Row
    getRowContent({"index":"Most Popular", "rowType":"popular"})
    for each category in m.config.tmdbConfig.defaultGenres.movie
      params = {"index":category, "rowType":"genre"}
      getRowContent(params)
    end for
    ' Can add Top Rated or other static categories here
    ' getRowContent({"index":"Top Rated", "rowType":"top"})
  end if
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
  ' ? "getRowContent at: "; url
  m.contentTask.control = "RUN"
end sub

sub onRowContentResponse(obj)
  m.top.apiCalls--
  nextRowData = obj.getData()
  if "Most Popular" = nextRowData.index 'To keep the most popular row at the top
    sortedArray = [nextRowData]
    sortedArray.append(m.rowContent)
    m.rowContent = sortedArray
  else
    m.rowContent.push(nextRowData)
  end if
  if 0 = m.top.apiCalls
    createHome()
  end if
end sub

sub getRowFallback()
  featuredContent = {"index":"Most Popular", "content":ParseJson(ReadAsciiFile("pkg:/config/fallback/featured_movie_fallback.json")).results}
  actionContent = {"index":"Action", "content":ParseJson(ReadAsciiFile("pkg:/config/fallback/action_movie_fallback.json")).results}
  comedyContent = {"index":"Comedy", "content":ParseJson(ReadAsciiFile("pkg:/config/fallback/comedy_movie_fallback.json")).results}
  dramaContent = {"index":"Drama", "content":ParseJson(ReadAsciiFile("pkg:/config/fallback/drama_movie_fallback.json")).results}
  ' ratedContent = {"index":"Top Rated", "content":ParseJson(ReadAsciiFile("pkg:/config/fallback/highest_rated_movie_fallback.json")).results}
  m.rowContent = [featuredContent, actionContent, comedyContent, dramaContent]
end sub

sub createHome()
  screen_home = m.top.createChild("Screen_Home")
  screen_home.rowContent = m.rowContent
  ' should probably set screenReady for screen_home here and hide splash
end sub
