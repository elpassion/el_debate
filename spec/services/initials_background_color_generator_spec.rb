require 'rails_helper'

describe InitialsBackgroundColorGenerator do
  it 'creates proper color' do
    expect(described_class.call).to be_in(described_class::POSSIBLE_COLORS)
  end
end
