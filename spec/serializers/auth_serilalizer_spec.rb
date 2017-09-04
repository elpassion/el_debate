require 'rails_helper'

describe AuthSerializer do
  let(:user) { create(:user, auth_token: auth_token) }
  let(:auth_token) { create(:auth_token) }
  let(:debate) { auth_token.debate }
  let(:serializer) { described_class.new(user, debate) }

  describe '#to_h' do
    subject { serializer.to_h }

    it 'returns auth_token' do
      expect(subject[:auth_token]).to eq(auth_token.value)
    end

    it 'returns user_id' do
      expect(subject[:user_id]).to eq(user.id)
    end

    it 'returns debate_closed value' do
      expect(subject[:debate_closed]).to eq(debate.closed?)
    end
  end
end
