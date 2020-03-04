import userInformationQuery from '~/graphql/users/information.gql'
import userSignInMutation from '~/graphql/users/signIn.gql'

export const state = () => {
  return {
    accessToken: null,
    currentUser: null,
    passwordShow: false,
    signedInSnackbar: false,
    signedOutSnackbar: false,
    signInDialog: false,
    signOutDialog: false,
    signInFormInvalid: false,
    signInFormInvalidMessage: null,
    submitLoading: false
  }
}

export const mutations = {
  SET_ACCESS_TOKEN: (state, accessToken) => {
    state.accessToken = accessToken
  },
  SET_CURRENT_USER: (state, currentUser) => {
    state.currentUser = currentUser
  },
  SET_PASSWORD_SHOW: (state) => {
    state.passwordShow = !state.passwordShow
  },
  SET_SIGN_IN_DIALOG: (state, signInDialog) => {
    state.signInDialog = signInDialog
  },
  SET_SIGN_OUT_DIALOG: (state, signOutDialog) => {
    state.signOutDialog = signOutDialog
  },
  SET_SIGN_IN_FORM_INVALID: (state, signInFormInvalid) => {
    state.signInFormInvalid = signInFormInvalid
  },
  SET_SIGN_IN_FORM_INVALID_MESSAGE: (state, signInFormInvalid) => {
    state.signInFormInvalid = signInFormInvalid
  },
  SET_SIGNED_IN_SNACK_BAR: (state, signedInSnackbar) => {
    state.signedInSnackbar = signedInSnackbar
  },
  SET_SIGNED_OUT_SNACK_BAR: (state, signedOutSnackbar) => {
    state.signedOutSnackbar = signedOutSnackbar
  },
  SET_SUBMIT_LOADING: (state, submitLoading) => {
    state.submitLoading = submitLoading
  }
}

export const getters = {
  isAuthenticated(state) {
    return !!state.accessToken
  },
  isLoggedIn(state) {
    return !!(state.currentUser && state.accessToken)
  },
  currentUser(state) {
    return state.currentUser || {}
  },
  passwordShow(state) {
    return !!state.passwordShow
  },
  signedInSnackbar(state) {
    return !!state.signedInSnackbar
  },
  signedOutSnackbar(state) {
    return !!state.signedOutSnackbar
  },
  signInDialog(state) {
    return !!state.signInDialog
  },
  signOutDialog(state) {
    return !!state.signOutDialog
  },
  signInFormInvalid(state) {
    return !!state.signInFormInvalid
  },
  signInFormInvalidMessage(state) {
    return state.signInFormInvalid
  },
  submitLoading(state) {
    return !!state.submitLoading
  }
}

export const actions = {
  async init({ commit, dispatch }) {
    if (!process.server) return
    const accessToken = this.app.$apolloHelpers.getToken()
    commit('SET_ACCESS_TOKEN', accessToken)
    await dispatch('currentUser')
  },

  async currentUser({ commit, dispatch }) {
    try {
      const
        client = this.app.apolloProvider.defaultClient,
        token = { token: this.$apolloHelpers.getToken() },
        res = await client.resetStore().then(() => {
          return client.query({ query: userInformationQuery, variables: token })
        }),
        userInformation = res.data.userInformation || {}

      commit('SET_CURRENT_USER', userInformation)
      console.error('OK')
    } catch (error) {
      console.error(error)
      // dispatch('signOut')
      // dispatch('openSignedOutSnackbar')
    }
  },

  async openSignInDialog ({ commit }) {
    commit('SET_SIGNED_IN_SNACK_BAR', false)
    commit('SET_SIGNED_OUT_SNACK_BAR', false)
    commit('SET_SIGN_IN_DIALOG', true)
  },

  async closeSignInDialog ({ commit }) {
    commit('SET_SIGN_IN_DIALOG', false)
  },

  async openSignOutDialog ({ commit }) {
    commit('SET_SIGNED_IN_SNACK_BAR', false)
    commit('SET_SIGNED_OUT_SNACK_BAR', false)
    commit('SET_SIGN_OUT_DIALOG', true)
  },

  async closeSignOutDialog ({ commit }) {
    commit('SET_SIGN_OUT_DIALOG', false)
  },

  async passwordToggle ({ commit }) {
    commit('SET_PASSWORD_SHOW')
  },

  async signIn ({ commit, dispatch }, variables) {
    commit('SET_SUBMIT_LOADING', true)
    try {
      const
        client = this.app.apolloProvider.defaultClient,
        res = await client.mutate({ mutation: userSignInMutation, variables: variables }),
        accessToken = res.data.userSignIn.accessToken

      this.$apolloHelpers.onLogin(accessToken)
      commit('SET_ACCESS_TOKEN', accessToken)
      commit('SET_SIGN_IN_FORM_INVALID', false)
      dispatch('currentUser')
      dispatch('openSignedInSnackbar')
      dispatch('closeSignInDialog')
    } catch (error) {
      commit('SET_SIGN_IN_FORM_INVALID', true)
      commit('SET_SIGN_IN_FORM_INVALID_MESSAGE', error.graphQLErrors[0].message)
    } finally {
      commit('SET_SUBMIT_LOADING', false)
    }
  },

  async openSignedInSnackbar ({ commit }) {
    commit('SET_SIGNED_OUT_SNACK_BAR', false)
    commit('SET_SIGNED_IN_SNACK_BAR', true)
  },

  async openSignedOutSnackbar ({ commit }) {
    commit('SET_SIGNED_IN_SNACK_BAR', false)
    commit('SET_SIGNED_OUT_SNACK_BAR', true)
  },

  async closeSignedInSnackbar ({ commit }) {
    commit('SET_SIGNED_IN_SNACK_BAR', false)
  },

  async closeSignedOutSnackbar ({ commit }) {
    commit('SET_SIGNED_OUT_SNACK_BAR', false)
  },

  async signOut ({ commit, dispatch }) {
    this.$apolloHelpers.onLogout()
    commit('SET_ACCESS_TOKEN', null)
    dispatch('closeSignOutDialog')
    dispatch('openSignedOutSnackbar')
  }
}