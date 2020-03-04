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
    signInInput: {
      email: ''
      password: ''
    }

  computed:
    passwordShow: ->
      @$store.getters['auth/passwordShow']

    refererRouteName: ->
      @$store.getters['auth/refererRouteName']

    signInFormInvalid: ->
      @$store.getters['auth/signInFormInvalid']

    signInFormInvalidMessage: ->
      @$store.getters['auth/signInFormInvalidMessage']

    submitLoading: ->
      @$store.getters['auth/submitLoading']

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
    passwordToggle: ->
      @$store.dispatch 'auth/passwordToggle'

    clearSignInForm: ->
      @$v.$reset()
      @signInInput.email = ''
      @signInInput.password = ''

    signIn: ->
      @$v.$touch()

      unless @$v.$invalid
        @$store.dispatch 'auth/signIn', @$v.signInInput.$model
        @clearSignInForm()
