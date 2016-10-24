require 'rails_helper'

describe VoteService do
  describe 'notifications' do
    let(:answer) { create(:answer)}
    let(:auth_token) { answer.debate.auth_tokens.create! }

    before do
      allow_any_instance_of(DebateNotifier).to receive(:notify).and_return false
    end

    it 'saves vote even if broadcaster does not notify user' do
      service = described_class.new(answer: answer, auth_token: auth_token)
      expect(service.vote!).to be_falsey
      expect(answer.debate.votes.count).to eq 1
    end
  end
end
