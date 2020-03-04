require 'rails_helper'

RSpec.describe Mutations::UserSignIn, type: :request do
  let(:variables) do
    {
      email: 'user@example.com',
      password: 'password'
    }
  end

  let(:mutation_string) do
    <<-GRAPHQL
    mutation userSignIn($email: String!, $password: String!) {
      userSignIn(input: {
        email: $email,
        password: $password
      }) {
        accessToken: token
      }
    }
    GRAPHQL
  end

  before { FactoryBot.create :user, variables }

  context 'with valid variables' do
    it "returns 'accessToken'" do
      mutation = ApiSchema.execute mutation_string, variables: variables
      expect(mutation['data']['userSignIn']['accessToken']).not_to be_nil
    end
  end

  context 'with invalid variables' do
    context 'when email is absent' do
      it "return 'userSignIn' as null" do
        variables['email'] = nil
        mutation = ApiSchema.execute mutation_string, variables: variables
        expect(mutation['data']['userSignIn']).to be_nil
      end
    end

    context 'when password is absent' do
      it "return 'userSignIn' as null" do
        variables['password'] = nil
        mutation = ApiSchema.execute mutation_string, variables: variables
        expect(mutation['data']['userSignIn']).to be_nil
      end
    end

    context 'when email & password are absent' do
      it "return 'userSignIn' as null" do
        variables['email'] = nil
        variables['password'] = nil
        mutation = ApiSchema.execute mutation_string, variables: variables
        expect(mutation['data']['userSignIn']).to be_nil
      end
    end

    context 'when unknown email' do
      it "return 'userSignIn' as null" do
        variables['email'] = 'unknown@example.com'
        mutation = ApiSchema.execute mutation_string, variables: variables
        expect(mutation['data']['userSignIn']).to be_nil
      end
    end

    context 'when wrong password' do
      it "does not return 'accessToken'" do
        variables['password'] = 'WrongPassword'
        mutation = ApiSchema.execute mutation_string, variables: variables
        expect(mutation['data']['userSignIn']['accessToken']).to be_nil
      end
    end
  end
end
