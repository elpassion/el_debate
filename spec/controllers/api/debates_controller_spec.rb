require 'rails_helper'

describe Api::DebatesController do
  let(:debate) { create(:debate) }
  let(:auth_token) { debate.auth_tokens.create }

  before do
    request.env['HTTP_AUTHORIZATION'] = auth_token.value
  end

  describe '#show' do
    subject do
      get :show
      response
    end

    let(:json_response) { JSON.parse(subject.body) }

    context 'when debate is opened' do
      it 'returns valid debates hash' do
        expect(subject).to have_http_status(:ok)
        expect(json_response).to include("topic" => debate.topic)
        expect(json_response).to include("answers" => hash_including('positive',
                                                                     'negative',
                                                                     'neutral'))
        expect(json_response).to include("last_answer_id")
      end
    end

    context 'when debate is closed' do
      let(:debate) { create(:debate, :closed_debate) }

      it 'returns valid debate closed error hash' do
        expect(subject).to have_http_status(:not_acceptable)
        expect(json_response).to include('error' => 'Debate is closed')
      end
    end
  end


end
