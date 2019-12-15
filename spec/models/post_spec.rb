require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'Validations' do
    it 'validate presence of require fields' do
      should validate_presence_of(:title)
    end
  end
end