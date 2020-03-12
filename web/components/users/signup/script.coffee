import { validationMixin } from 'vuelidate'
import { email, minLength, maxLength, required, sameAs } from 'vuelidate/lib/validators'
import { mask } from 'vue-the-mask'

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
    passwordConfirmationGraphQLErrors: []

    signUpFormErrors: null

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
    birthdayLoading: ->
      @$store.getters['auth/birthdayLoading']

    passwordIcon: ->
      @$store.getters['auth/passwordIcon']

    passwordType: ->
      @$store.getters['auth/passwordType']

    passwordConfirmationIcon: ->
      @$store.getters['auth/passwordConfirmationIcon']

    passwordConfirmationType: ->
      @$store.getters['auth/passwordConfirmationType']

    submitLoading: ->
      @$store.getters['auth/submitLoading']

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
    birthdayLoaded: ->
      @$store.dispatch 'auth/birthdayLoaded'

    birthdayToggle: ->
      @birthdayStatus = !@birthdayStatus

    passwordToggle: ->
      @$store.dispatch 'auth/passwordToggle'

    passwordConfirmationToggle: ->
      @$store.dispatch 'auth/passwordConfirmationToggle'

    signUpButtonToggle: ->
      !@disableSignUpButtonRouteNames.includes @$route.name

    submitSignUpForm: ->
      @$v.$touch()

      unless @$v.$invalid
        @$store.dispatch 'auth/signUp', @$v.signUpInput.$model

  mounted: ->
    @birthdayLoaded()

  watch:
    birthdayStatus: (val) ->
      val && setTimeout =>
        @$refs.picker.activePicker = 'YEAR'
