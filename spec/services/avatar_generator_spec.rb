require 'rails_helper'

describe AvatarGenerator do
  subject do
    described_class.new('test_identifier')
  end

  it 'creates proper url' do
    expect(URI.parse(subject.generate_url)).to be_a URI::HTTPS
    expect(subject.generate_url).to include('test_identifier')
  end
end
