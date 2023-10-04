sub init()

  m.config = ParseJson(ReadAsciiFile("pkg:/config/config.json"))

  m.keyboard = m.top.FindNode("keyboard")
  m.searchBtn = m.top.FindNode("searchBtn")
  m.searchBtn.ObserveFieldScoped("buttonSelected", "searchBtnInput")
  m.searchLbl = m.top.FindNode("searchLbl")

  m.resultsGrid = m.top.FindNode("resultsGrid")
  m.resultsGrid.ObserveFieldScoped("itemSelected", "resultSelected")
  m.searchLoadingOverlay = m.top.FindNode("searchLoadingOverlay")

end sub

sub searchBtnInput(event)
  input = event.getData()
  key = "?api_key=" + m.config.api_keys.tmdbKey
  rating = m.config.tmdbConfig.rating
  lang = m.config.tmdbConfig.language
  url = m.config.tmdbConfig.baseUrl + "search/movie" + key + rating + lang + "&query=" + m.keyboard.text
  m.contentTask = createObject("roSGNode", "restTask")
  m.contentTask.observeField("response", "onSearchResponse")
  m.contentTask.request = {"url":url, "index":"Search"}
  ? "Search for content: "; url
  m.searchLoadingOverlay.visible = true
  m.contentTask.control = "RUN"
end sub

sub onSearchResponse(obj)
  response = obj.getData()
  m.results = response.content
  m.resultsGridContent = createObject("roSGNode","ContentNode")
  if 0 = m.results.count()
    m.searchLbl.text = "No Results for "+ chr(34) + m.keyboard.text + chr(34)
  else
    m.searchLbl.text = "Search Results for "+ chr(34) + m.keyboard.text + chr(34)
    for each result in m.results
      gridposter = createObject("roSGNode","ContentNode")
      if invalid <> result.poster_path
        gridposter.hdposterurl = "https://image.tmdb.org/t/p/w200/"+result.poster_path
        gridposter.sdposterurl = "https://image.tmdb.org/t/p/w200/"+result.poster_path
      else
        gridposter.hdposterurl = "pkg:/assets/images/posterPlaceholder.png"
        gridposter.sdposterurl = "pkg:/assets/images/posterPlaceholder.png"
      end if
      m.resultsGridContent.appendChild(gridposter)
    end for
    m.resultsGrid.content = m.resultsGridContent
    m.resultsGrid.setFocus(true)
  end if
  m.searchLoadingOverlay.visible = false
  m.searchLbl.visible = true
end sub

sub resultSelected(obj)
  selection = obj.getData()
  ? "Selection: "; m.results[selection]
end sub

sub clearSearch()
  m.searchLbl.visible = false
  m.resultsGrid.visible = false
  m.keyboard.text = ""
end sub

sub screenShow()
  m.keyboard.setFocus(true)
  m.global.screenManager.screenReady = true
  m.top.visible = true
end sub

function onKeyEvent(key, press) as Boolean
  handled = false
  if press
    if "down" = key
      if m.keyboard.isInFocusChain()
        m.searchBtn.setFocus(true)
      end if
    else if "up" = key
      if m.searchBtn.hasFocus()
        m.keyboard.setFocus(true)
      end if
    else if "options" = key
    else if "left" = key
      if m.resultsGrid.isInFocusChain()
        m.keyboard.setFocus(true)
      end if
    else if "right" = key
      if m.resultsGrid.visible
        m.resultsGrid.setFocus(true)
      end if
    else if "back" = key
      if m.resultsGrid.isInFocusChain()
        m.keyboard.setFocus(true)
      else
        clearSearch()
        ? "Go Back!"
        m.global.screenManager.callFunc("goBack", {"index":"SearchScreen", "previousScreen":"HomeScreen"})
      end if
      handled = true
    end if
  end if
  return handled
end function
