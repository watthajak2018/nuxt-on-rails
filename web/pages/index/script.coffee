export default
  data: ->
    { msg: '' }

  methods:
    getHello: ->
      res = await @$axios.$get '/hello'
      @msg = res.msg
