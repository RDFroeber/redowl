assert = require 'assert'

MovieRatingsResource = require '../app/movie-ratings'

describe 'MovieRatingsResource', ->

  movieRatings = {}

  beforeEach ->
    movieRatings = new MovieRatingsResource
      'Bladerunner': [5, 1]
      'The Empire Strikes Back': [1, 1, 2, 3, 5]

  describe '#getAllMovieRatings()', ->

    it 'should return the correct ratings for all movies', ->
      assert.deepEqual movieRatings.getAllMovieRatings()['Bladerunner'].sort(), [1,5]
      assert.deepEqual movieRatings.getAllMovieRatings()['The Empire Strikes Back'].sort(), [1,1,2,3,5]
      
  describe '#getMovieRatings()', ->

    it 'should return the correct movie ratings for the requested movie', ->
      assert.deepEqual movieRatings.getMovieRatings('Bladerunner').sort(), [1,5]

    it 'should throw an error if the requested movie does not exist in the repo', ->
      assert.throws (-> movieRatings.getMovieRatings('Gone Girl')), /Movie does not exist in repository/

  describe '#putMovieRatings()', ->

    it 'should put a new movie with ratings into the repo and return the ratings', ->
      assert.deepEqual movieRatings.putMovieRatings('Gone Girl', [4,3]).sort(), [3,4]

    it 'should overwrite the ratings of an existing movie in the repo and return the new ratings', ->
      assert.deepEqual movieRatings.putMovieRatings('Bladerunner', [4,3]).sort(), [3,4]

  describe '#postMovieRating()', ->

    it 'should put a new movie with rating into the repo if it does not already exist and return the rating', ->
      assert.deepEqual movieRatings.postMovieRating('Captain America', 5), [5]

    it 'should add a new rating to an existing movie in the repo and return the ratings', ->
      assert.deepEqual movieRatings.postMovieRating('Bladerunner', 4).sort(), [1, 4, 5]

  describe '#deleteMovieRatings()', ->

    it 'should delete a movie from the ratings repo', ->
      assert.equal movieRatings.deleteMovieRatings('Bladerunner'), true

    it 'should throw an error when attempting to delete a movie that does not exist', ->
      assert.throws (-> movieRatings.deleteMovieRatings('X-Men')), /Movie does not exist in repository/