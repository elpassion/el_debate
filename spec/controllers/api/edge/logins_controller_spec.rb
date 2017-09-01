require 'rails_helper'

describe Api::Edge::LoginsController, type: :controller do
  subject do
    action
    response
  end

  let(:action) { post :create, params: params }
  let(:debate) { create(:debate) }
  let(:json_response) { JSON.parse(subject.body) }

  let(:params) do
    { code: debate.code }
  end

  context 'when debate not found' do
    let(:params) do
      { code: '12345' }
    end

    it 'return not found status' do
      expect(subject).to have_http_status(:not_found)
    end

    it 'returns proper error message' do
      expect(json_response).to include('error')
      expect(json_response['error']).to eq('Debate not found')
    end

    it 'does not create user' do
      expect { subject }.not_to change { User.count }
    end
  end

  context 'when everything is ok' do
    it 'returns success status' do
      expect(subject).to have_http_status(:success)
    end

    it 'returns auth token' do
      expect(json_response).to include('auth_token')
    end

    it 'creates user' do
      expect { subject }.to change { User.count }.by 1
    end
  end

  context 'when debate is closed' do
    let(:debate) { create(:debate, :closed_debate) }

    let(:params) do
      { code: debate.code, username: 'Abc' }
    end

    it 'returns not_acceptable status with error message' do
      expect(subject).to have_http_status(:not_acceptable)
      expect(json_response).to include('error')
      expect(json_response['error']).to eq('Debate is closed')
    end
  end

  context 'when debate is opened' do
    let(:params) do
      { code: debate.code, username: 'Abc' }
    end

    it 'returns debate_closed flag set to false' do
      expect(json_response['debate_closed']).to eq false
    end
  end
end
