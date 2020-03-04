export default
  middleware: 'authenticated'

  computed:
    currentUser: ->
      @$store.getters['auth/currentUser']

  methods:
    loadCurrentUser: ->
      @$store.dispatch 'auth/currentUser'

  mounted: ->
#     @loadCurrentUser()
