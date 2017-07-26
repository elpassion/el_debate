require 'rails_helper'

describe CommentSerializer do
  let(:debate) { create(:debate) }
  let(:auth_token) { debate.auth_tokens.create }
  let(:mobile_user) { create(:edge_mobile_user, auth_token: auth_token, first_name: 'John', last_name: 'Doe') }
  let(:comment) { create(:comment, user: mobile_user) }

  subject { described_class.new(comment).to_h }

  it 'receives valid data' do
    expect(subject).to have_key(:user_initials_background_color)
    expect(subject[:user_initials]).to eq('J D')
  end
end

