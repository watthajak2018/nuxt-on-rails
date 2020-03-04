import postListQuery from '~/graphql/posts/list.gql'

export default
  data: ->
    posts: []
    isActive: false

  methods:
    loadPosts: ->
      res = await @$apollo.query query: postListQuery
      @posts = res.data.blogposts

  mounted: ->
    @loadPosts()
