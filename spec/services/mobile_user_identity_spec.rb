require 'rails_helper'

describe MobileUserIdentity do
  let(:params) { { first_name: 'other_first_name',
                   last_name: 'other_last_name' } }

  subject { described_class.new(user, params).call }

  context 'When user has no first_name and last_name at initialize' do
    let(:user) { create(:mobile_user) }
    it 'chenge user identify' do
      subject
      user.reload
      expect(user.first_name).to eq(params[:first_name])
    end
  end

  context 'When user has set first_name and last_name at initialize' do
    let(:user) { create(:mobile_user, first_name: 'some_first_name', last_name: 'some_last_name') }
    it 'chenge user identify' do
      subject
      user.reload
      expect(user.first_name).to_not eq(params[:first_name])
    end
  end
end
