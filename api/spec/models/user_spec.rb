require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build :user }

  describe 'FactoryBot initialized state' do
    it 'be valid' do
      expect(user).to be_valid
    end
  end
end
