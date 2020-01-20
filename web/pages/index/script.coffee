export default
  data: ->
    { colors: [] }

  methods:
    updateColors: ->
      @colors = await @$axios.$get '/colors'

  mounted: ->
    @updateColors()
