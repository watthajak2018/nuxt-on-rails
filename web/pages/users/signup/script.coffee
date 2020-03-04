import userSingUpComponent from '~/components/users/signup'

export default
  middleware: 'notAuthenticated'

  components:
    'user-sing-up': userSingUpComponent

  computed:
    isLoggedIn: ->
      @$store.getters['auth/isLoggedIn']

  watch:
    isLoggedIn: ->
      @isLoggedIn && @$router.push '/'
