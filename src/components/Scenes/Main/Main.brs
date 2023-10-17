sub init()
  m.top.backgroundColor = "0x000000FF"
  m.top.backgroundURI = ""
  m.loadingOverlay = m.top.findNode("loadingOverlay")
  ScreenManager = createObject("roSGNode", "ScreenManager")
  m.global.addFields({"screenManager":ScreenManager})
  m.global.screenManager.ObserveFieldScoped("screenReady", "hideLoadingOverlay")
  m.useFallbacks = false
  m.rowContent = []
  m.config = ParseJson(ReadAsciiFile("pkg:/config/config.json"))
  m.global.addFields({"config": m.config})
  m.catIDs = ParseJson(ReadAsciiFile("pkg:/config/categoryIds.json"))
  getUserRegData()
  ' buildRows()
end sub

sub getUserRegData()
  'Categories
  regSec = CreateObject("roRegistrySection", "CategorySection")
  if regSec.Exists("CategorySection")
    response = regSec.Read("CategorySection")
    ? "Response from registry: "
    m.categories = ParseJson(response)
  else
    ? "Category Data not found!"
    m.categories = []
    for each category in m.config.tmdbConfig.defaultGenres.movie
      m.categories.push({"title":category, "state":false})
    end for
    m.categories[2].state = true
    m.categories[1].state = true
    m.categories[0].state = true
    regSec.Write("CategorySection", FormatJson(m.categories))
  end if
  regSec.Flush()
  buildRows()
end sub

sub buildRows()
  if m.useFallbacks
    getRowFallback()
    createHome()
  else
    getRowContent({"index":"Most Popular", "rowType":"popular"}) 'Featured Row
    ' getRowContent({"index":"Top Rated", "rowType":"top"})
    for each category in m.categories
      if category.state
        params = {"index":category.title, "rowType":"genre"}
        getRowContent(params)
      end if
    end for
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
  ? "getRowContent at: "; url
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
  params = {
    "index":"HomeScreen",
    "content":m.rowContent
  }
  m.global.screenManager.callFunc("openScreen", params)
end sub

sub hideLoadingOverlay(obj)
  status = obj.getData()
  if status
    m.loadingOverlay.visible = false
  else
    m.loadingOverlay.visible = true
  end if
end sub