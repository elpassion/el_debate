require 'rails_helper'

describe AuthToken, type: :model do
  it 'generates token value' do
    auth_token = create(:auth_token)
    expect(auth_token.value).not_to be_blank
  end

  it 'validates debate existence' do
    auth_token = build(:auth_token, debate: nil)
    expect(auth_token).not_to be_valid
    expect(auth_token.errors[:debate]).to include('must exist')
  end
end
