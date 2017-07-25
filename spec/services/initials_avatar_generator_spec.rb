require 'rails_helper'

describe InitialsAvatarGenerator do
  it 'creates proper color' do
    expect(ReceiveAllowedColors.call).to include(described_class.call)
  end
end
