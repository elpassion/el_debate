require 'rails_helper'

describe DebatePresenter do
  let(:debate) { create(:debate) }
  let(:positive_vote!) { create(:vote, answer: debate.positive_answer) }
  let(:negative_vote!) { create(:vote, answer: debate.negative_answer) }

  describe '#positive_count_with_person' do
    it 'returns an amount of people voted for a positive answer' do
      positive_vote!
      expect(described_class.new(debate).positive_count_with_person).to eq('1 person')
    end
  end

  describe '#negative_count_with_person' do
    it 'returns an amount of people voted for a negative answer' do
      negative_vote!
      expect(described_class.new(debate).negative_count_with_person).to eq('1 person')
    end
  end

  describe '#positive_percent' do
    it 'returns 0% for no votes' do
      expect(described_class.new(debate).positive_percent).to eq('0%')
    end

    it 'returns an amount in percent of people voted for a positive answer' do
      positive_vote!
      expect(described_class.new(debate).positive_percent).to eq('100%')
    end
  end

  describe '#negative_percent' do
    it 'returns 0% for no votes' do
      expect(described_class.new(debate).negative_percent).to eq('0%')
    end

    it 'returns an amount in percent of people voted for a negative answer' do
      negative_vote!
      expect(described_class.new(debate).negative_percent).to eq('100%')
    end
  end
end
