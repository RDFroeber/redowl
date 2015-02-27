define ['vendor/jquery'], ($) ->
  module = {}

  module.getAllMovieRatings = (callback) -> $.get '/api/movieratings', callback

  module.getMovieRating = (movie, callback) -> $.get '/api/ratemovie/' + movie, callback

  module.putMovieRatings = (movie, ratings, callback) -> $.put '/api/movieratings/' + movie, callback

  module.postMovieRating = (movie, rating, callback) -> $.post '/api/movieratings/' + movie, callback

  module.deleteMovieRatings = (movie, callback) -> $.delete '/api/movieratings/' + movie, callback

  return module