require 'rails_helper'

describe DashboardHelper, type: :helper do
  describe '#pluralize_without_count' do
    it 'returns singular noun when count equals 1' do
      expect(pluralize_without_count(1, 'person')).to eq('person')
    end

    it 'returns plural noun when count equals 0 or more than 1' do
      expect(pluralize_without_count(0, 'person')).to eq('people')
      expect(pluralize_without_count(2, 'person')).to eq('people')
    end

    it 'does not return anything if count is less than 0' do
      expect(pluralize_without_count(-1, 'person')).to be_nil
    end
  end
end
