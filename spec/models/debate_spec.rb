require 'rails_helper'

describe Debate, type: :model do
  it 'sets code on create' do
    debate = create(:debate, code: nil)
    expect(debate.code?).to be_truthy
  end

  it 'validates topic presence' do
    debate = build(:debate, topic: nil)
    expect(debate).not_to be_valid
    expect(debate.errors[:topic]).to include("can't be blank")
  end

  describe 'class methods' do

    let(:debate) { create(:debate) }
    let(:positive_vote!) { create(:vote, answer: debate.positive_answer) }
    let(:negative_vote!) { create(:vote, answer: debate.negative_answer) }
    let(:neutral_vote!) { create(:vote, answer: debate.neutral_answer) }

    describe '#positive_count' do
      it 'returns an amount of votes given for positive answer' do
        positive_vote!
        expect(debate.positive_count).to eq 1
      end
    end

    describe '#negative_count' do
      it 'returns an amount of votes given for negative answer' do
        negative_vote!
        expect(debate.negative_count).to eq 1
      end
    end

    describe '#neutral_count' do
      it 'returns an amount of votes given for neutral answer' do
        neutral_vote!
        expect(debate.neutral_count).to eq 1
      end
    end
  end
end
