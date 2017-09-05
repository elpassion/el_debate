require 'rails_helper'

describe UserIdentity do
  let(:params) { { first_name: 'other_first_name',
                   last_name: 'other_last_name' } }

  subject { described_class.new(user).update(first_name: params[:first_name], last_name: params[:last_name]) }

  context 'when user has no first_name and last_name at initialize' do
    let(:user) { create(:user, first_name: nil, last_name: nil) }
    it 'changes user identify' do
      subject
      expect(user.first_name).to eq(params[:first_name])
    end
  end

  context 'when user has set first_name and last_name at initialize' do
    let(:user) { create(:user, first_name: 'some_first_name', last_name: 'some_last_name') }
    it 'changes user identify' do
      subject
      expect(user.first_name).to_not eq(params[:first_name])
    end
  end
end
