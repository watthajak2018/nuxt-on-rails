require 'rails_helper'

RSpec.describe Blogpost, type: :model do
  let(:blogpost) { FactoryBot.build :blogpost }

  describe 'FactoryBot initialized state' do
    it 'be valid' do
      expect(blogpost).to be_valid
    end
  end
end
