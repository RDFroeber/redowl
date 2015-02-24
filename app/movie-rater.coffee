_ = require 'underscore'

module.exports = (ratings) ->
  if ratings !instanceof Array or arguments.length isnt 1
    throw new Error 'Invalid arguments'
  else if ratings.length < 3 or _.uniq(ratings).length < 3
    throw new Error 'Not enough ratings'
  else
    min = Math.min.apply @, ratings
    max = Math.max.apply @, ratings
    trimmed = _.without(ratings, min, max)
    (trimmed.reduce (a, b) -> a + b) / trimmed.length