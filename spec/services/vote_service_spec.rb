require 'rails_helper'

describe VoteService do
  let(:auth_token) { create(:auth_token) }
  let(:answer) { create(:answer, debate: auth_token.debate) }

  describe 'notifications' do
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

  describe '#vote!' do
    let(:new_answer) { create(:answer, debate: auth_token.debate) }
    let!(:old_vote) { create(:vote, answer: answer, auth_token: auth_token) }
    let(:vote_service) { VoteService.new(answer: new_answer, auth_token: auth_token) }
    let(:notifier) { double('notifier', notify: true) }

    it 'replaces older vote for given auth token' do
      expect { vote_service.vote!(notifier) }.not_to change { Vote.count }
      expect(auth_token.vote).not_to eq(:old_vote)
    end

    it 'deletes existing votes for given auth token' do
      old_id = old_vote.id
      vote_service.vote!(notifier)
      expect(Vote.pluck(:id)).not_to include(old_id)
    end

    it 'deos not delete old votes if something goes wrong' do
      allow(vote_service).to receive(:create_vote!).and_raise('something went wrong')

      expect { vote_service.vote!(notifier) rescue nil }.not_to change { Vote.count }
      expect(auth_token.vote).to eq(old_vote)
    end
  end
end
