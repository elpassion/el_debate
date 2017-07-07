require 'rails_helper'

describe VoteService do
  let(:auth_token) { create(:auth_token) }
  let(:debate) { auth_token.debate }
  let(:notifier) { double(:notifier, notify_about_votes: true) }
  let(:answer_1) { debate.positive_answer }
  let(:vote_service) { described_class.new(answer: answer_1, auth_token: auth_token) }
  subject { vote_service.vote!(notifier) }

  it 'sends a notification' do
    expect(notifier).to receive(:notify_about_votes)
    subject
  end

  describe '#vote!' do
    let(:answer_2) { debate.negative_answer }

    it 'creates a new vote' do
      expect { subject }.to change { answer_1.votes_count }.by 1
    end

    context 'when the user has already voted' do
      let!(:vote) { create(:vote, answer: answer_2, auth_token: auth_token) }

      it 'changes the vote' do
        expect { subject }.to change { vote.reload.answer }.from(answer_2).to(answer_1)
      end

      it 'changes answers vote counters' do
        expect { subject }.to change {
          [answer_1.reload.votes_count, answer_2.reload.votes_count]
        }.from(
          [0, 1]
        ).to(
          [1, 0]
        )
      end
    end
  end
end
