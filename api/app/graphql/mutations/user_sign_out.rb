module Mutations
  class UserSignOut < BaseMutation
    graphql_name 'UserSignOut'

    argument :token, String, required: true

    def resolve(token:)
      user = User.find_by! JsonWebToken.decode token
      raise GraphQL::ExecutionError, 'Invalid access token.' unless user.update(jti: User.generate_jti)
    end
  end
end
