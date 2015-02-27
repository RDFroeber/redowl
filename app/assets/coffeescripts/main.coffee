requirejs.config
  baseUrl: '/javascripts'
  paths:
    vendor: './vendor'
  shim:
    'vendor/jquery':
      exports: 'jQuery'
    'vendor/underscore':
      exports: '_'
    'vendor/handlebars':
      exports: 'Handlebars'

dependencies = [
  'vendor/jquery'
  'vendor/underscore'
  'vendor/handlebars'
  'movie-ratings-service-client'
]

requirejs dependencies, ($, _, Handlebars, ratingsService) ->   

  movieRatingsTemplate = """
                        <div class='container'>
                          <div class='movie-ratings'>
                            <h1>Movie Ratings</h1>
                            {{#each movieRatings}}
                              <h2>{{@key}}</h2>
                              <h3 class='all-ratings'>All Ratings:</h3>
                              <p class='all-ratings'>{{this}}</p>
                           
                              {{> addRating this}}
                              {{> deleteMovie this}}
                            {{/each}}
                          </div>

                          <div class='sidebar'>
                            <h2>Current Ratings</h2>
                            <div class='current-rating'>
                            </div>

                            <h3>Add a Movie</h3>
                            {{> addMovie}}
                          </div>
                        </div>
                         """

  ratedMoviesTemplate = """
                          <h3>{{movie}}:
                          {{#if isBad}}
                            <span class="bad"> {{rating}}</span>
                          {{else}}
                            <span>{{rating}}</span>
                          {{/if}}
                          </h3>
                       """

  Handlebars.registerPartial 'addRating', """
                        <form class="post-rating" action="/api/movieratings/{{@key}}">
                          <label for="rating">Add Rating</label>
                          <input type="number" name="rating" placeholder="Your rating"/>

                          <input type="submit" value="Add"/>
                        </form>
                       """

  Handlebars.registerPartial 'addMovie', """
                        <form class="add-movie">
                          <label for="movie">Movie</label>
                          <input type="text" name="movie" id="name" placeholder="Movie title"/>

                          <label for="rating">Rating</label>
                          <input type="number" name="rating" placeholder="Your rating"/>

                          <input type="submit" value="Add"/>
                        </form>
                       """

  Handlebars.registerPartial 'deleteMovie', """
                        <form class="delete-movie" action="/api/movieratings/{{@key}}">
                          <label for="delete">Delete {{@key}}?</label>

                          <input type="submit" value="Yes, delete it!"/>
                        </form>
                       """

  movieRatingsSection = Handlebars.compile movieRatingsTemplate
  ratedMoviesSection = Handlebars.compile ratedMoviesTemplate

  ratingsService.getAllMovieRatings (ratings) ->
    $('body').append movieRatingsSection { movieRatings: ratings }
    $('form.add-movie').on 'submit', (e) ->
      e.preventDefault()
      $.ajax({
          url: '/api/movieratings/' + $('form.add-movie #name').val(),
          type: 'POST',
          data: $(this).serialize()
        }).done (data) ->
          location.href = '/'

    $('form.post-rating').on 'submit', (e) ->
      e.preventDefault()
      $.ajax({
          url: $(this).attr('action'),
          type: 'POST',
          data: $(this).serialize()
        }).done (data) ->
          location.href = '/'

    $('form.delete-movie').on 'submit', (e) ->
      e.preventDefault()
      $.ajax({
          url: $(this).attr('action'), 
          type: 'DELETE',
          data: $(this).serialize()
        }).done (data) ->
          location.href = '/'

    for movie of ratings
      do (movie) ->
        ratingsService.getMovieRating movie, (rating) ->
          if rating < 3 then isBad = true else isBad = false
          $('.current-rating').append ratedMoviesSection {movie: movie, rating: rating, isBad: isBad}
