export default function ({ store, redirect }) {
  !store.getters['auth/isAuthenticated'] && redirect('/users/signin')
}
