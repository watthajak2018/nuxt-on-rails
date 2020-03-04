module Types
  class QueryType < Types::BaseObject
    field :blogposts, resolver: Resolvers::Blogposts
    field :user_information, resolver: Queries::UserInformation

    field :blogpost, Types::BlogpostType, null: false do
      argument :id, ID, required: true
    end

    def blogpost(id:)
      Blogpost.find id
    end
  end
end
