import { validationMixin } from 'vuelidate'
import { required, email } from 'vuelidate/lib/validators'

export default
  mixins: [validationMixin]

  validations:
    signInInput:
      email: {
        required
        email
      }

      password: {
        required
      }

  data: ->
    disableSignUpButtonRouteNames: [
      'users-signin'
      'users-signup'
    ]

    signInInput: {
      email: ''
      password: ''
    }

  computed:
    isAuthenticated: ->
      @$store.getters['auth/isAuthenticated']

    signInDialog: ->
      @$store.getters['auth/signInDialog']

    signOutDialog: ->
      @$store.getters['auth/signOutDialog']

    passwordShow: ->
      @$store.getters['auth/passwordShow']

    signInFormInvalid: ->
      @$store.getters['auth/signInFormInvalid']

    signInFormInvalidMessage: ->
      @$store.getters['auth/signInFormInvalidMessage']

    submitLoading: ->
      @$store.getters['auth/submitLoading']

    signedInSnackbar:
      get: ->
        @$store.getters['auth/signedInSnackbar']

      set: ->
        @$store.getters['auth/signedInSnackbar']

    signedOutSnackbar:
      get: ->
        @$store.getters['auth/signedOutSnackbar']

      set: ->
        @$store.getters['auth/signedOutSnackbar']

    emailErrors: ->
      errors = []
      if !@$v.signInInput.email.$dirty
        return errors
      !@$v.signInInput.email.email && errors.push 'Must be valid e-mail'
      !@$v.signInInput.email.required && errors.push 'E-mail is required'
      errors

    passwordErrors: ->
      errors = []
      if !@$v.signInInput.password.$dirty
        return errors
      !@$v.signInInput.password.required && errors.push 'Password is required'
      errors

  methods:
    signUpButtonToggle: ->
      !@disableSignUpButtonRouteNames.includes @$route.name

    openSignInDialog: ->
      @$store.dispatch 'auth/openSignInDialog'

    closeSignInDialog: ->
      @$store.dispatch 'auth/closeSignInDialog'
      @clearSignInForm()

    openSignOutDialog: ->
      @$store.dispatch 'auth/openSignOutDialog'

    closeSignOutDialog: ->
      @$store.dispatch 'auth/closeSignOutDialog'

    passwordToggle: ->
      @$store.dispatch 'auth/passwordToggle'

    clearSignInForm: ->
      @$v.$reset()
      @signInInput.email = '' unless @signInDialog
      @signInInput.password = ''

    closeSignedInSnackbar: ->
      @$store.dispatch 'auth/closeSignedInSnackbar'

    closeSignedOutSnackbar: ->
      @$store.dispatch 'auth/closeSignedOutSnackbar'

    signIn: ->
      @$v.$touch()

      unless @$v.$invalid
        @$store.dispatch 'auth/signIn', @$v.signInInput.$model
        @clearSignInForm()

    signOut: ->
      @$store.dispatch 'auth/signOut'

  watch:
    $route: ->
      @$store.dispatch 'auth/closeSignedInSnackbar'
      @$store.dispatch 'auth/closeSignedOutSnackbar'
