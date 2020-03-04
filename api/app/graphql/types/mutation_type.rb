module Types
  class MutationType < Types::BaseObject
    # field :create_blogpost, mutation: Mutations::CreateBlogpost
    field :user_sign_up, mutation: Mutations::UserSignUp
    field :user_sign_in, mutation: Mutations::UserSignIn
    field :user_sign_out, mutation: Mutations::UserSignOut
  end
end
