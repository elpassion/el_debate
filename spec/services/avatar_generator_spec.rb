require 'rails_helper'

describe AvatarGenerator do
  describe '#generate_url' do
    subject do
      described_class.new('test_identifier')
    end

    it 'creates proper url' do
      expect(subject.generate_url).to eq 'https://api.adorable.io/avatars/80/test_identifier'
    end
  end
end
