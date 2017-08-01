require 'rails_helper'

describe MobileUser, type: :model do

  context 'when last_name is short' do
    let(:mobile_user) { create(:mobile_user, first_name: 'John', last_name: 'Doe') }

    it 'checks users valid initials and full name' do
      expect(mobile_user.full_name).to eq('John Doe')
      expect(mobile_user.initials).to eq('JD')
    end
  end

  context 'when last_name is long' do
    let(:mobile_user) { create(:mobile_user, first_name: 'John', last_name: 'Last-LastName') }

    it 'checks users valid initials and full name' do
      expect(mobile_user.full_name).to eq('John Last-lastname')
      expect(mobile_user.initials).to eq('JL')
    end
  end
end
