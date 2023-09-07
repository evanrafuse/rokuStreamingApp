sub init()
  ' getContent()
  createHome()
end sub

sub getContent(params)
  ' Params for url args

  args = ""
  url = ""
  ' url = baseUrl + args + key + rating + language
  m.contentTask = createObject("roSGNode", "restTask")
  m.contentTask.observeField("response", "onContentResponse")
  m.contentTask.request = {"url":url}
  ' ? "getContent at: "; url
  m.contentTask.control = "RUN"
end sub

sub onContentResponse(obj)
  response = obj.getData()
  contentData = ParseJson(response)
end sub

sub createHome()
  screen_home = m.top.createChild("Screen_Home")
  featuredContent = ParseJson(ReadAsciiFile("pkg:/config/featured_movie_fallback.json")).results
  ratedContent = ParseJson(ReadAsciiFile("pkg:/config/highest_rated_movie_fallback.json")).results
  actionContent = ParseJson(ReadAsciiFile("pkg:/config/action_movie_fallback.json")).results
  rows = [featuredContent, ratedContent, actionContent]

  rowContentData = CreateObject("roSGNode", "ContentNode")
  for each row in rows
    contentData = rowContentData.CreateChild("ContentNode")
    contentData.title = "Row"
    for each show in row
      newShow = contentData.CreateChild("ContentNode")
      newShow.title = show.title
      posterUrl = "https://image.tmdb.org/t/p/w200" + show.poster_path
      newShow.HDPosterUrl = posterUrl
    end for
  end for
  screen_home.rowContent = rowContentData
end sub
