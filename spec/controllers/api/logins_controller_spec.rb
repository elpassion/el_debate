require 'rails_helper'

describe Api::LoginsController, type: :controller do
  let(:debate) { create(:debate) }

  let(:params) do
    {
      code: debate.code,
      username: 'Abc'
    }
  end

  context 'when debate not found' do
    before { post :create, params: { code: '12345' } }

    it 'return not found status' do
      expect(response).to have_http_status(:not_found)
    end

    it 'returns proper error message' do
      json_response = JSON.parse(response.body)
      expect(json_response).to include('error')
      expect(json_response['error']).to eq('Debate not found')
    end
  end

  context 'when username exists in debate' do
    before do
      create(:mobile_user, auth_token: create(:auth_token, debate: debate), name: params[:username])
      post :create, params: params
    end

    it 'returns bad request status' do
      expect(response).to have_http_status(:bad_request)
    end

    it 'returns proper error message' do
      json_response = JSON.parse(response.body)
      expect(json_response).to include('error')
      expect(json_response['error']).to eq('Name has to be unique')
    end
  end

  context 'when everything is ok' do
    subject { post :create, params: params }

    it 'returns success status' do
      subject
      expect(response).to have_http_status(:success)
    end

    it 'returns auth token' do
      subject
      json_response = JSON.parse(response.body)
      expect(json_response).to include('auth_token')
    end

    it 'creates mobile user' do
      expect{ subject }.to change{ MobileUser.count }.by 1
    end
  end

  context 'when debate is closed' do
    let(:debate) { create(:debate, :closed_debate) }

    before do
      post :create, params: { code: debate.code }
    end

    it 'returns debate_closed flag set to true' do
      json_response = JSON.parse(response.body)
      expect(json_response['debate_closed']).to eq true
    end
  end

  context 'when debate is opened' do
    before do
      post :create, params: { code: debate.code }
    end

    it 'returns debate_closed flag set to false' do
      json_response = JSON.parse(response.body)
      expect(json_response['debate_closed']).to eq false
    end
  end
end
