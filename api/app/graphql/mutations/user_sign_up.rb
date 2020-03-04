module Mutations
  class UserSignUp < BaseMutation
    graphql_name 'UserSignUp'

    argument :first_name, String, required: true
    argument :last_name, String, required: true
    argument :sex_id, String, required: true
    argument :birthday, GraphQL::Types::ISO8601Date, required: true
    argument :phone_number, String, required: true
    argument :email, String, required: true
    argument :password, String, required: true
    argument :password_confirmation, String, required: true
    argument :role, String, required: true

    field :token, String, null: true

    def resolve(**args)
      user = User.new args
      raise GraphQL::ExecutionError, user.errors.messages.to_json unless user.save

      { token: JsonWebToken.encode(user.jwt_payload) }
    end
  end
end
