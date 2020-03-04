export default async function ({ store, route, redirect }) {
  if (store.getters['auth/isAuthenticated']) return
  store.dispatch('auth/setRefererRouteName', route.name)
  await redirect('/users/signin')
}
