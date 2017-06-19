require 'rails_helper'

describe Api::LoginsController, type: :controller do
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
    let(:debate) { create(:debate) }

    before do
      post :create, params: { code: debate.code }
    end

    it 'returns debate_closed flag set to false' do
      json_response = JSON.parse(response.body)
      expect(json_response['debate_closed']).to eq false
    end
  end
end
