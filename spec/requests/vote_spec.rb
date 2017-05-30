require 'rails_helper'

describe 'Voting', type: :request do
  let(:auth_token) { create(:auth_token) }

  it 'cools down user when next voting request is made within 5 seconds' do
    post api_vote_path, params: { id: auth_token.debate.answers.sample.id }, headers: { 'Authorization' => auth_token.value }
    expect(response).to have_http_status :success
    post api_vote_path, params: { id: auth_token.debate.answers.sample.id }, headers: { 'Authorization' => auth_token.value }
    expect(response).to have_http_status 429
    expect(JSON.parse(response.body)).to eq({ 'status' => 'request_limit_reached' })
  end
end
