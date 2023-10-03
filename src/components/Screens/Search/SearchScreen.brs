sub init()

  m.config = ParseJson(ReadAsciiFile("pkg:/config/config.json"))

  m.keyboard = m.top.FindNode("keyboard")
  m.searchBtn = m.top.FindNode("searchBtn")
  m.searchBtn.ObserveFieldScoped("buttonSelected", "searchBtnInput")
  m.searchLbl = m.top.FindNode("searchLbl")

  m.resultsGrid = m.top.FindNode("resultsGrid")
  m.resultsGrid.ObserveFieldScoped("itemSelected", "resultSelected")
  m.searchLoadingOverlay = m.top.FindNode("searchLoadingOverlay")

  m.sideBar = m.top.findNode("sideBar")
  m.sideBarAnim = m.top.findNode("sideBarAnim")
  m.sideBarSlideAnim = m.top.findNode("sideBarSlideAnim")
  m.sideBar.ObserveFieldScoped("focusSideBar","animateSideBar")

  m.keyboard.setFocus(true)
end sub

sub searchBtnInput(event)
  input = event.getData()
  url = "https://api.themoviedb.org/3/search/movie?include_adult=false&language=en-US&page=1" + "&api_key=" + m.config.api_keys.tmdbKey + "&query=" + m.keyboard.text
  m.searchLbl.text = "Search Results for "+ chr(34) + m.keyboard.text + chr(34)
  m.keyboard.text = ""
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
  for each result in m.results
    gridposter = createObject("roSGNode","ContentNode")
    if invalid <> result.poster_path
      gridposter.hdposterurl = "https://image.tmdb.org/t/p/w200/"+result.poster_path
      gridposter.sdposterurl = "https://image.tmdb.org/t/p/w200/"+result.poster_path
    else
      gridposter.hdposterurl = "pkg:/assets/images/posterPlaceholder.png"
      gridposter.sdposterurl = "pkg:/assets/images/posterPlaceholder.png"
    end if
    gridposter.shortdescriptionline1 = "TEST 1"
    gridposter.shortdescriptionline2 = "TEST 2"
    m.resultsGridContent.appendChild(gridposter)
  end for
  m.resultsGrid.content = m.resultsGridContent
  m.searchLoadingOverlay.visible = false
  m.searchLbl.visible = true
  m.resultsGrid.setFocus(true)
end sub

sub resultSelected(obj)
  selection = obj.getData()
  ? "Selection: "; m.results[selection]
end sub

sub animateSideBar(obj)
  showing = obj.getData()
  if showing
    m.sideBarSlideAnim.keyValue = [[-200,0],[0,0]]
  else
    m.sideBarSlideAnim.keyValue = [[0,0],[-200,0]]
    m.keyboard.setFocus(true)
  end if
  m.sideBarAnim.control = "start"
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
      m.sideBar.focusSideBar = true
    else if "left" = key
      if m.keyboard.isInFocusChain() or m.searchBtn.hasFocus()
        m.sideBar.focusSideBar = true
      else
        m.keyboard.setFocus(true)
      end if
    else if "right" = key
      if m.resultsGrid.visible
        m.resultsGrid.setFocus(true)
      end if
    end if
  end if
  return handled
end function
