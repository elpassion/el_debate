require 'rails_helper'

describe Api::VotesController, type: :controller do
  let(:debate) { create(:debate) }
  let(:auth_token) { debate.auth_tokens.create }

  before do
    token = ActionController::HttpAuthentication::Token.encode_credentials(auth_token.value)
    request.env['HTTP_AUTHORIZATION'] = token
  end

  context 'when answer not found' do
    let(:answer_id) { Answer.maximum(:id) + 1 }

    before { post :create, params: { id: answer_id } }

    it 'returns 404 response status' do
      expect(response).to have_http_status(404)
    end

    it 'returns proper message' do
      json_response = JSON.parse(response.body)
      expect(json_response).to include('error')
      expect(json_response['error']).to eq('Answer not found')
    end
  end

  context 'when answer found' do
    let(:answer_id) { debate.answers.sample.id }

    before { post :create, params: { id: answer_id } }

    it 'returns 201 response status' do
      expect(response).to have_http_status(201)
    end

    it 'returns empty body' do
      expect(response.body).to be_blank
    end
  end

  context 'when debate closed' do
    let(:answer_id) { debate.answers.sample.id }

    before { debate.close!(Time.now - 1.hour) }
    before { post :create, params: { id: answer_id } }

    it 'returns 406 response status' do
      expect(response).to have_http_status(406)
    end

    it 'returns proper message' do
      json_response = JSON.parse(response.body)
      expect(json_response).to include('error')
      expect(json_response['error']).to eq('Debate is closed')
    end
  end
end
