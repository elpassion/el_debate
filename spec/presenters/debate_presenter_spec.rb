require 'rails_helper'

describe DebatePresenter do
  let(:debate) { OpenStruct.new(positive_count: 5,
                                negative_count: 45,
                                neutral_count: 10,
                                votes_count: 60) }

  let(:subject) { described_class.new(debate) }

  describe '#positive_count_with_person' do
    it 'returns an amount of people voted for a positive answer' do
      debate = OpenStruct.new(positive_count: 1)
      expect(described_class.new(debate).positive_count_with_person).to eq('1 person')
    end
  end

  describe '#negative_count_with_person' do
    it 'returns an amount of people voted for a negative answer' do
      expect(subject.negative_count_with_person).to eq('45 people')
    end
  end

  describe '#positive_percent' do
    it 'returns 0% for no votes' do
      debate.positive_count = 0
      expect(described_class.new(debate).positive_percent).to eq('0%')
    end

    it 'returns an amount in percent of people voted for a positive answer' do
      expect(subject.positive_percent).to eq('10%')
    end
  end

  describe '#negative_percent' do
    it 'returns 0% for no votes' do
      debate.negative_count = 0
      expect(described_class.new(debate).negative_percent).to eq('0%')
    end

    it 'returns an amount in percent of people voted for a negative answer' do
      expect(subject.negative_percent).to eq('90%')
    end
  end

  describe '#votes_count' do
    it 'counts positive and negative votes only' do
      expect(subject.votes_count).to eq(debate.positive_count + debate.negative_count + debate.neutral_count)
    end
  end
end
