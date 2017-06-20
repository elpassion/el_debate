require 'rails_helper'

describe MobileUserForm do
  let(:debate) { create(:debate) }
  let(:mobile_user) { build(:mobile_user, auth_token: create(:auth_token, debate: debate)) }
  subject { described_class.new(mobile_user) }

  describe '#validate' do
    it 'validates uniqueness of name' do
      MobileUser.create(name: 'a', auth_token: create(:auth_token, debate: debate))
      expect(subject.validate({ name: 'a' })).to be_falsey
      expect(subject.errors[:name]).to include('has to be unique')
    end
  end
end
