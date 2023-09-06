sub init()
  ' getContent()
  createHome()
end sub

sub getContent(params)
  ' Params for url args
  ' Featured Movies = discover/movie
  ' Popular Movie = movie/popular
  ' Top Rated Movies = movie/top_rated
  ' Individual Movie = “movie/“ + ID
  ' Swap tv for movie for series

  baseUrl = "https://api.themoviedb.org/3/"
  args = ""
  key = "?api_key=5d9ba89dd8dddbd9f424a39c2e9993ec"
  rating = "&include_adult=false"
  language = "&language=en-US"
  sortby = "&sort_by=popularity.desc"
  genre = "&with_genres=action"

  url = baseUrl + args + key + rating + language
  m.contentTask = createObject("roSGNode", "restTask")
  m.contentTask.observeField("response", "onContentResponse")
  m.contentTask.request = {"url":url}
  ? "getContent at: "; url
  m.contentTask.control = "RUN"
end sub

sub onContentResponse(obj)
  response = obj.getData()
  contentData = ParseJson(response)
end sub

sub createHome()
  screen_home = m.top.createChild("Screen_Home")
  featuredContent = ParseJson(ReadAsciiFile("pkg:/assets/config/featured_movie_fallback.json")).results
  ratedContent = ParseJson(ReadAsciiFile("pkg:/assets/config/highest_rated_movie_fallback.json")).results
  actionContent = ParseJson(ReadAsciiFile("pkg:/assets/config/action_movie_fallback.json")).results
  rows = [featuredContent, ratedContent, actionContent]

  rowContentData = CreateObject("roSGNode", "ContentNode")
  for each row in rows
    contentData = rowContentData.CreateChild("ContentNode")
    contentData.title = "Row"
    for each show in row
      newShow = contentData.CreateChild("ContentNode")
      newShow.title = show.title
      posterUrl = "https://image.tmdb.org/t/p/w500" + show.poster_path
      newShow.HDPosterUrl = posterUrl
    end for
  end for
  ? "Type is: "; type(rowContentData)
  screen_home.rowContent = rowContentData
end sub
