import userSingInComponent from '~/components/users/signIn'

export default
  middleware: 'notAuthenticated'

  components:
    'user-sing-in': userSingInComponent

  computed:
    isLoggedIn: ->
      @$store.getters['auth/isLoggedIn']

  watch:
    isLoggedIn: ->
      @isLoggedIn && @$router.push '/'
