module Mutations
  class UserSignIn < BaseMutation
    graphql_name 'UserSignIn'

    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: true

    def resolve(email:, password:)
      user = User.find_for_authentication email: email
      user_is_valid = user&.valid_for_authentication? { user&.valid_password? password }
      raise GraphQL::ExecutionError, 'Invalid email or password.' unless user && user_is_valid

      { token: JsonWebToken.encode(user.jwt_payload) }
    end
  end
end
