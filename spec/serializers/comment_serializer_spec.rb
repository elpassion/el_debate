require 'rails_helper'

describe CommentSerializer do
  let(:debate) { create(:debate) }
  let(:auth_token) { debate.auth_tokens.create }
  let(:mobile_user) { create(:edge_mobile_user, auth_token: auth_token, first_name: 'John', last_name: 'Doe') }
  let(:comment) { create(:comment, user: mobile_user) }

  it 'receives valid data' do
    call = described_class.new(comment).to_h
    expect(call).to include(:user_initials_avatar_color)
    expect(call[:user_initials]).to eq('J D')
  end
end
