module Types
  class QueryType < Types::BaseObject
    field :user_information, resolver: Queries::UserInformation

    end
  end
end
