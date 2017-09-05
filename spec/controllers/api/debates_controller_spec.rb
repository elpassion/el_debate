require 'rails_helper'

describe Api::DebatesController do
  before do
    request.env['HTTP_AUTHORIZATION'] = auth_token.value
  end

  context 'when debate is opened' do
    let(:debate) { create(:debate) }
    let(:auth_token) { debate.auth_tokens.create }

    it 'returns valid debates hash' do
      get :show
      json_response = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(json_response).to include("topic")
      expect(json_response).to include("answers")
      expect(json_response).to include("last_answer_id")
    end
  end

  context 'when debate is closed' do
    let(:debate) { create(:debate, :closed_debate) }
    let(:auth_token) { debate.auth_tokens.create }

    it 'returns valid debate closed error hash' do
      get :show
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status(:not_acceptable)
      expect(json_response).to include('error')
      expect(json_response['error']).to eq('Debate is closed')
    end
  end
end
