module Queries
  class UserInformation < Queries::BaseQuery
    type Types::UserType, null: false

    argument :token, String, required: true

    def resolve(token:)
      User.find_by JsonWebToken.decode token
    end
  end
end
