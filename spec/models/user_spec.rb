require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Validations' do
    it 'should validates uniqueness of email' do
      should validate_uniqueness_of(:email).ignoring_case_sensitivity
    end
  end
end