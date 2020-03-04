import userSignInMutation from '~/graphql/users/signIn.gql'

export const state = () => ({
  data: null
})

export const mutations = {
  SET_DATA(state, theData) {
    state.data = theData
  }
}

export const actions = {
  async nuxtServerInit({ dispatch }) {
    // await dispatch('auth/init')
    await dispatch('storeDispatchFunc')
  },
  async storeDispatchFunc({ commit }) {
    const
      client = this.app.apolloProvider.defaultClient,
      { data } = await client.mutate({
        mutation: userSignInMutation,
        variables: {
          email: 'user+1@example.com',
          password: 'password'
        }
      })

    commit('SET_DATA', data)
  }
}
