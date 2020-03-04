export default
  data: ->
    slides: [
      {
        title: 'First'
        color: 'indigo'
      }
      {
        title: 'Second'
        color: 'warning'
      }
      {
        title: 'Third'
        color: 'pink darken-2'
      }
      {
        title: 'Fourth'
        color: 'red lighten-1'
      }
      {
        title: 'Fifth'
        color: 'deep-purple accent-4'
      }
    ]

    skeletonLoaders: [
      'avatar'
      'list-item-avatar'
      'list-item'
      'image'
      'article'
      'paragraph'
      'actions'
      'article, actions'
      'card-avatar'
      'card-avatar, article, actions'
      'date-picker-days'
      'date-picker'
    ]

  inject: ['theme']
