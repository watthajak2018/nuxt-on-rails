require 'rails_helper'

RSpec.describe Mutations::UserSignIn, type: :request do
  let(:user_variables) do
    {
      email: 'user@example.com',
      password: 'password',
      jti: User.generate_jti
    }
  end

  let(:user) do
    FactoryBot.create :user, user_variables
  end

  let(:mutation_string) do
    <<-GRAPHQL
    mutation userSignOut($token: String!) {
      userSignOut(input: {
        token: $token
      }) {
        clientMutationId
      }
    }
    GRAPHQL
  end

  context 'with valid accessToken' do
    subject do
      token = JsonWebToken.encode user.jwt_payload
      ApiSchema.execute mutation_string, variables: { token: token }
    end

    it "returns 'userSignOut' as nil" do
      expect(subject['userSignOut']).to be_nil
    end

    it "user's jti has changed" do
      subject
      jti_was = user.jti
      expect(user.reload.jti).not_to eq jti_was
    end
  end

  context 'with invalid accessToken' do
    context "when user's jti is absent" do
      subject do
        user[:jti] = nil
        token = JsonWebToken.encode user.jwt_payload
        ApiSchema.execute mutation_string, variables: { token: token }
      end

      it 'returns error messages' do
        expect { subject }.to raise_error JWT::InvalidJtiError, 'Missing jti'
      end
    end

    context "when user's jti is incorrect" do
      subject do
        user[:jti] = User.generate_jti
        token = JsonWebToken.encode user.jwt_payload
        ApiSchema.execute mutation_string, variables: { token: token }
      end

      it 'returns error messages' do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound, "Couldn't find User"
      end
    end

    context 'when signature is wrong' do
      before do
        Devise.secret_key = 'test'
      end

      subject do
        secret_key = SecureRandom.hex 64
        token = JWT.encode user.jwt_payload, secret_key, 'HS256', typ: 'JWT'
        ApiSchema.execute mutation_string, variables: { token: token }
      end

      it 'returns error messages' do
        expect { subject }.to raise_error JWT::VerificationError, 'Signature verification raised'
      end
    end

    context 'when unknown user' do
      subject do
        user = FactoryBot.build :user, user_variables
        token = JsonWebToken.encode user.jwt_payload
        ApiSchema.execute mutation_string, variables: { token: token }
      end

      it 'returns error messages' do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound, "Couldn't find User"
      end
    end
  end
end
