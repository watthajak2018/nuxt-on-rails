module Types
  class QueryType < Types::BaseObject
    field :blogposts, resolver: Resolvers::Blogposts
    field :user_information, resolver: Queries::UserInformation

    end
  end
end
