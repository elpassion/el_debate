require 'rails_helper'

describe Debates::ResetService do
  let(:debate)          { create(:debate) }
  let(:positive_answer) { debate.answers.positive.take }
  let(:neutral_answer)  { debate.answers.neutral.take }
  let(:negative_answer) { debate.answers.negative.take }
  
  subject { described_class.new(debate: debate) }

  before do
    create :vote, answer: positive_answer
    create :vote, answer: positive_answer
    create :vote, answer: neutral_answer
    create :vote, answer: negative_answer
  end

  it 'changes all votes in the debate to neutral' do
    expect { subject.call }.to change {
      [positive_answer.votes.count, neutral_answer.votes.count, negative_answer.votes.count]
    }.from(
      [2, 1, 1]
    ).to(
      [0, 4, 0]
    )
  end
end
