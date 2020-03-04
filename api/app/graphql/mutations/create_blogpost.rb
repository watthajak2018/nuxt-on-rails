module Mutations
  class CreateBlogpost < BaseMutation
    graphql_name 'CreateBlogpost'

    field :blogpost, Types::BlogpostType, null: true
    field :errors, [String], null: true

    argument :title, String, required: true
    argument :body, String, required: true
    argument :user_id, ID, required: true

    def resolve(**args)
      record = Blogpost.new args
      if record.save
        { blogpost: record, errors: [] }
      else
        { blogpost: nil, errors: record.errors.full_messages }
      end
    end
  end
end
