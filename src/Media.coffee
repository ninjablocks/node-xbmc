debug = require('debug') 'xbmc:Media'

class Media
  @mixin: (api) ->
    debug 'mixin'
    @api = api
    api.media = {}
    api.media[name] = method for name, method of @
    delete api.media.mixin

  @episode: (id) =>
    debug 'episode', id
    dfd = @api.send 'VideoLibrary.GetEpisodeDetails',
      episodeid: id
      properties: [
        'title'
        'showtitle'
        'plot'
        'season'
        'episode'
        'thumbnail'
      ]
    dfd.then (data) =>
      @api.emit 'api:episode', @api.scrub data.result.episodedetails

  @movies: (options = {}, fn = null) =>
    debug 'movies', options
    args =
      properties: options.properties || []
      sort:       options.sort       || {}
      limits:     options.limits     || {}
    dfd = @api.send 'VideoLibrary.GetMovies', args
    dfd.then (data) =>
      @api.emit 'api:movies', data.result.movies
      fn data if fn

  @movie: (id, fn = null) =>
    debug 'movie', id
    dfd = @api.send 'VideoLibrary.GetMovieDetails',
      movieid: id
      properties: [
        'title'
        'year'
        'plotoutline'
        'plot'
        'thumbnail'
      ]
    dfd.then (data) =>
      d = @api.scrub data.result.moviedetails
      @api.emit 'api:movie', d
      fn d if fn

module.exports = Media
