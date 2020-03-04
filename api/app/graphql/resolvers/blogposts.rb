module Resolvers
  class Blogposts < Resolvers::Base
    type [Types::BlogpostType], null: false

    def resolve
      Blogpost.all.includes :user
    end
  end
end
