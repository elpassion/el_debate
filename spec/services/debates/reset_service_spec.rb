require 'rails_helper'

describe Debates::ResetService do
  let(:debate)          { create(:debate) }
  let(:notifier)        { double(DebateNotifier) }
  let(:positive_answer) { debate.positive_answer }
  let(:neutral_answer)  { debate.neutral_answer }
  let(:negative_answer) { debate.negative_answer }
  
  subject { described_class.new(debate: debate, notifier: notifier).call }

  before do
    create :vote, answer: positive_answer
    create :vote, answer: positive_answer
    create :vote, answer: neutral_answer
    create :vote, answer: negative_answer
    allow(notifier).to receive(:notify_about_reset)
  end

  it 'changes all votes in the debate to neutral' do
    expect { subject }.to change {
      [positive_answer.votes.count, neutral_answer.votes.count, negative_answer.votes.count]
    }.from(
      [2, 1, 1]
    ).to(
      [0, 4, 0]
    )
  end

  it 'sends a notification' do
    expect(notifier).to receive(:notify_about_reset).with(debate)
    subject
  end
end
