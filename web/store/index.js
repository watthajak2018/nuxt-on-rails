export const actions = {
  nuxtServerInit({ dispatch }) {
    dispatch('auth/init')
  },
  nuxtClientInit({ dispatch }) {
    dispatch('auth/currentUser')
  }
}
