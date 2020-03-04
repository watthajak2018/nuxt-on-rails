module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :firstName, String, null: false
    field :lastName, String, null: false
    field :sexId, String, null: false
    field :birthday, GraphQL::Types::ISO8601Date, null: false
    field :phoneNumber, String, null: false
    field :email, String, null: false
    field :role, String, null: false
  end
end
