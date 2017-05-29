require 'rails_helper'

describe VoteService do
  let(:auth_token) { create(:auth_token) }
  let(:debate) { auth_token.debate }
  let(:answer) { debate.answers.sample }

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
    let(:notifier) { double('notifier', notify: true) }
    let(:new_answer) { debate.answers.first }
    let!(:old_vote) { create(:vote, answer: answer, auth_token: auth_token) }
    let(:vote_service) { VoteService.new(answer: new_answer, auth_token: auth_token) }

    it 'updates answer_id if previous vote exists' do
      expect { vote_service.vote!(notifier) }.to_not change { Vote.count }
      expect(auth_token.vote.answer_id).to eq(new_answer.id)
    end

    it 'does not delete old votes if something goes wrong' do
      expect { vote_service.vote!(notifier) rescue nil }.not_to change { Vote.count }
      expect(auth_token.vote).to eq(old_vote)
    end

    Answer.answer_types.keys.each do |existing_type|
      Answer.answer_types.keys.reject { |t| t == existing_type }.each do |new_type|
        context "when changing from #{existing_type} to #{new_type}" do
          let(:answer) { debate.send("#{existing_type}_answer") }
          let(:new_answer) { debate.send("#{new_type}_answer") }

          it "decrements debate #{existing_type}_count" do
            expect { vote_service.vote!(notifier) }.to change { debate.send("#{existing_type}_count") }.by(-1)
          end

          it "increments debate #{new_type}_count" do
            expect { vote_service.vote!(notifier) }.to change { debate.send("#{new_type}_count") }.by(1)
          end
        end
      end
    end
  end
end
