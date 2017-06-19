require 'rails_helper'

describe AvatarGenerator do
  let(:auth_token) { create(:auth_token) }

  subject do
    described_class.new(auth_token.value)
  end

  it 'creates proper url' do
    expect(URI.parse(subject.generate_avatar_url)).to be_a URI::HTTPS
  end
end
