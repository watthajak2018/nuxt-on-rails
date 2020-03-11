module Types
  class MutationType < Types::BaseObject
    field :user_sign_up, mutation: Mutations::UserSignUp
    field :user_sign_in, mutation: Mutations::UserSignIn
  end
end
