require 'rails_helper'

describe AuthSerializer do
  let(:user) { create(:user, auth_token: auth_token) }
  let(:auth_token) { create(:auth_token) }
  let(:debate) { auth_token.debate }
  let(:serializer) { described_class.new(user, debate) }

  describe '#to_h' do
    subject { serializer.to_h }

    it 'should include auth_token' do
      expect(subject).to include(auth_token: auth_token.value)
    end

    it 'should include user_id' do
      expect(subject).to include(user_id: user.id)
    end

    it 'should include debate_closed' do
      expect(subject).to include(debate_closed: debate.closed?)
    end
  end
end
