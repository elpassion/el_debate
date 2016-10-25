require 'rails_helper'

describe VoteService do
  describe 'notifications' do
    let(:answer) { create(:answer)}
    let(:auth_token) { answer.debate.auth_tokens.create! }
    let(:notifier) { double('notifier') }
    let(:service) { described_class.new(answer: answer, auth_token: auth_token) }

    it 'saves vote even if broadcaster does not notify user' do
      allow(notifier).to receive(:notify).and_return false
      expect(service.vote!(notifier)).to be_falsey
      expect(answer.debate.votes_count).to eq 1
    end

    it 'calls notifier #notify method' do
      expect(notifier).to receive(:notify)
      service.vote!(notifier)
    end
  end
end
