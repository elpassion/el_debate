require 'rails_helper'

describe DebatePresenter do
  let(:debate) { OpenStruct.new(positive_count: 1,
                                negative_count: 50,
                                neutral_count: 0,
                                votes_count: 51) }

  describe '#positive_count_with_person' do
    it 'returns an amount of people voted for a positive answer' do
      expect(described_class.new(debate).positive_count_with_person).to eq('1 person')
    end
  end

  describe '#negative_count_with_person' do
    it 'returns an amount of people voted for a negative answer' do
      expect(described_class.new(debate).negative_count_with_person).to eq('50 people')
    end
  end

  describe '#positive_percent' do
    it 'returns 0% for no votes' do
      debate.positive_count = 0
      expect(described_class.new(debate).positive_percent).to eq('0%')
    end

    it 'returns an amount in percent of people voted for a positive answer' do
      expect(described_class.new(debate).positive_percent).to eq('2%')
    end
  end

  describe '#negative_percent' do
    it 'returns 0% for no votes' do
      debate.negative_count = 0
      expect(described_class.new(debate).negative_percent).to eq('0%')
    end

    it 'returns an amount in percent of people voted for a negative answer' do
      expect(described_class.new(debate).negative_percent).to eq('98%')
    end
  end
end
