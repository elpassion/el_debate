require 'rails_helper'

describe 'Voting', type: :request do
  let(:auth_token) { create(:auth_token) }

  before { Timecop.freeze }
  after { Timecop.return }

  it 'cools down user when more than 2 requests are made within 1 second' do
    multiple_post_request(3)
    expect(response).to have_http_status 429
    expect(JSON.parse(response.body)).to eq({ 'status' => 'request_limit_reached' })
  end

  def multiple_post_request(x)
    x.times do
      post api_vote_path, params: { id: auth_token.debate.answers.sample.id }, headers: { 'Authorization' => auth_token.value }
    end
  end
end
