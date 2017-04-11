require 'rails_helper'

describe Debate, type: :model do
  it 'validates topic presence' do
    debate = build(:debate, topic: '')
    expect(debate).not_to be_valid
    expect(debate.errors[:topic]).to include("can't be blank")
  end

  it 'deletes answers when destroyed' do
    debate = create(:debate)
    expect { debate.destroy }.to change { Answer.count }
  end

  it 'deletes debate auth tokens when destroyed' do
    debate = create(:debate)
    create(:auth_token, debate: debate)
    expect { debate.destroy }.to change { AuthToken.count }
  end


  describe '#code' do
    let(:debate) { create(:debate) }

    it 'has 5 characters' do
      expect(debate.code.length).to eq(5)
    end

    it 'has only digits' do
      expect(debate.code).to match(/\A\d+\z/)
    end

    it 'is generated when model created' do
      expect(debate.code).not_to be_blank
    end

    it 'cannot be changed' do
      code = debate.code
      debate.update! code: 12345
      debate.reload

      expect(debate.code).to eq(code)
    end

    it 'persists code between model updates' do
      code = debate.code
      debate.update! topic: FFaker::HipsterIpsum.sentence
      expect(debate.code).to eq(code)
    end
  end

  describe '#closed?' do
    let(:closed_at) { Time.current }
    let(:debate) { create(:debate, closed_at: closed_at) }

    it 'is closed when closed_at time is in the past' do
      expect(debate.closed?(closed_at + 1.hour)).to be
    end

    it 'is not closed when closed_at is not in the past' do
      expect(debate.closed?(closed_at - 1.hour)).not_to be
    end

    it 'is not closed when closed_at is not set' do
      debate = create(:debate, closed_at: nil)
      expect(debate.closed?).not_to be
    end
  end

  describe 'counter class methods' do
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
