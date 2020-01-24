module.exports = {
  head: {
    title: 'nuxt-on-rails',
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: 'Nuxt.js project' }
    ],
    link: [
      { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }
    ]
  },
  loading: { color: '#3B8070' },
  buildModules: [
    '@nuxtjs/vuetify',
    '~/modules/loaders/coffee',
    '~/modules/loaders/eslint'
  ],
  watchers: {
    webpack: {
      aggregateTimeout: 300,
      poll: 1000
    }
  }
};
