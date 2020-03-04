import { validationMixin } from 'vuelidate'
import { email, minLength, maxLength, required, sameAs } from 'vuelidate/lib/validators'
import { mask } from 'vue-the-mask'
import userSignUpMutation from '~/graphql/users/signUp.gql'

export default
  inject: ['theme']

  mixins: [validationMixin]

  directives: {
    mask
  }

  data: ->
    signUpInput: {
      firstName: ''
      lastName: ''
      sexId: ''
      birthday: ''
      phoneNumber: ''
      password: ''
      passwordConfirmation: ''
      role: ''
    }

    signUpInputSexIds: [
      'male'
      'female'
    ]

    signUpInputRoles: [
      'administrator'
      'publisher'
      'viewer'
    ]

    birthdayStatus: false
    phoneNumberMask: '###-###-####'
    emailGraphQLErrors: []
    passwordStatus: false
    passwordConfirmationStatus: false
    passwordConfirmationGraphQLErrors: []

    formLoading: true
    signUpFormErrors: null
    submitLoader: null
    submitLoading: false

  validations:
    signUpInput:
      firstName: {
        maxLength: maxLength(255)
        required
      }

      lastName: {
        maxLength: maxLength(255)
        required
      }

      sexId: {
        required
      }

      birthday: {
        required
      }

      phoneNumber: {
        tel: (tel) ->
          return true if typeof tel == 'undefined' or tel == null or tel == ''
          return /^[0-9+-\\(\\) ]+$/.test(tel)

        minLength: minLength(10)
        required
      }

      email: {
        email
        required
      }

      password: {
        minLength: minLength(8)
        required
      }

      passwordConfirmation: {
        sameAsPassword: sameAs('password')
        required
      }

      role: {
        required
      }

  computed:
    passwordShow: ->
      @$store.getters['auth/passwordShow']

    firstNameErrors: ->
      errors = []
      return errors if !@$v.signUpInput.firstName.$dirty
      !@$v.signUpInput.firstName.maxLength && errors.push "First Name's length must be less than 255"
      !@$v.signUpInput.firstName.required && errors.push 'First Name is required'
      errors

    lastNameErrors: ->
      errors = []
      return errors if !@$v.signUpInput.lastName.$dirty
      !@$v.signUpInput.lastName.maxLength && errors.push "Last Name's length must be less than 255"
      !@$v.signUpInput.lastName.required && errors.push 'Last Name is required'
      errors

    sexIdErrors: ->
      errors = []
      return errors if !@$v.signUpInput.sexId.$dirty
      !@$v.signUpInput.sexId.required && errors.push 'Gender is required'
      errors

    birthdayErrors: ->
      errors = []
      return errors if !@$v.signUpInput.birthday.$dirty
      !@$v.signUpInput.birthday.required && errors.push 'Birthday is required'
      errors

    phoneNumberErrors: ->
      errors = []
      return errors if !@$v.signUpInput.phoneNumber.$dirty
      !@$v.signUpInput.phoneNumber.tel && errors.push 'Phone Number is invalid'
      !@$v.signUpInput.phoneNumber.minLength && errors.push 'Phone Number must be 10 digits'
      !@$v.signUpInput.phoneNumber.required && errors.push 'Phone Number is required'
      errors

    emailErrors: ->
      errors = []
      return errors if !@$v.signUpInput.email.$dirty
      !@$v.signUpInput.email.email && errors.push 'Email is invalid'
      !@$v.signUpInput.email.required && errors.push 'Email is required'
      errors

    passwordErrors: ->
      errors = []
      return errors if !@$v.signUpInput.password.$dirty
      !@$v.signUpInput.password.minLength && errors.push 'Password must be greater than 6 characters'
      !@$v.signUpInput.password.required && errors.push 'Password is required'
      errors

    passwordConfirmationErrors: ->
      errors = []
      return errors if !@$v.signUpInput.passwordConfirmation.$dirty
      !@$v.signUpInput.passwordConfirmation.sameAsPassword && errors.push 'Password Confirmation is not match'
      !@$v.signUpInput.passwordConfirmation.required && errors.push 'Password Confirmation is required'
      errors

    roleErrors: ->
      errors = []
      return errors if !@$v.signUpInput.role.$dirty
      !@$v.signUpInput.role.required && errors.push 'Role is required'
      errors

  methods:
    birthdayToggle: ->
      @birthdayStatus = !@birthdayStatus

    passwordToggle: ->
      @$store.dispatch 'auth/passwordToggle'

    passwordConfirmationToggle: ->
      @passwordConfirmationStatus = !@passwordConfirmationStatus

    formLoaded: ->
      @formLoading = false

    signUpButtonToggle: ->
      !@disableSignUpButtonRouteNames.includes @$route.name

    submitSignUpForm: ->
      @$v.$touch()

      unless @$v.$invalid
        @submitLoader = 'submitLoading'
        @mutateSignUpForm()

      @emailGraphQLErrors = []
      @passwordConfirmationGraphQLErrors = []

    mutateSignUpForm: ->
      try
        res = await @$apollo.mutate mutation: userSignUpMutation, variables: @$v.signUpInput.$model
        @signUp(res.data.userCreate.accessToken)
        @signUpFormLoaded()

      catch error
        @signUpFormLoaded()
        errorMessages = JSON.parse(error.graphQLErrors[0].message)
        errorMessages.email && @emailGraphQLErrors = errorMessages.email
        errorMessages.password_confirmation && @passwordConfirmationGraphQLErrors = errorMessages.password_confirmation

    signUpFormLoaded: ->
      @submitLoading = false
      @submitLoader = null

    signUp: (accessToken) ->
      this.$apolloHelpers.onLogin accessToken
      @$store.commit 'SET_ACCESS_TOKEN', accessToken
      @$router.push '/users/information'

  mounted: ->
    @formLoaded()

  watch:
    birthdayStatus: (val) ->
      val && setTimeout =>
        @$refs.picker.activePicker = 'YEAR'

    submitLoader: ->
      submitLoader = @submitLoader
      @[submitLoader] = !@[submitLoader]
