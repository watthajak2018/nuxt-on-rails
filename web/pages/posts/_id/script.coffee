import postIdQuery from '~/graphql/posts/id.gql'

export default
  data: ->
    post: []

  methods:
    loadPost: ->
      res = await @$apollo.query query: postIdQuery, variables: @$route.params
      @post = res.data.blogpost

  mounted: ->
    @loadPost()
