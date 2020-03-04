export default
  middleware: 'authenticated'

  computed:
    isLoggedIn: ->
      @$store.getters['auth/isLoggedIn']

    currentUser: ->
      @$store.getters['auth/currentUser']

  watch:
    isLoggedIn: ->
      @isLoggedIn || @$router.push '/'
