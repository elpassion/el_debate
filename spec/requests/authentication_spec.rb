require 'rails_helper'

describe 'Authentication', type: :request do
  let(:auth_token) { create(:auth_token) }

  it 'unauthorize a request if there is no token given in header' do
    post api_vote_path
    expect(response).to have_http_status :unauthorized
  end

  it 'authorize user when proper token is passed' do
    get api_debate_path, params: {}, headers: { 'Authorization' => auth_token.value }
    expect(response).to have_http_status :success
  end
end
