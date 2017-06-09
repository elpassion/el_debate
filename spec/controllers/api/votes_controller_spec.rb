require 'rails_helper'

describe Api::VotesController, type: :controller do
  let(:debate) { create(:debate) }
  let(:auth_token) { debate.auth_tokens.create }

  before do
    request.env['HTTP_AUTHORIZATION'] = auth_token.value
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
    let(:debate) { create(:debate, :closed_debate) }

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

  context 'when changing vote' do
    let(:new_answer_id) { create(:answer, debate: debate).id }

    before do
      answer = create(:answer, debate: debate)
      create(:vote, answer: answer, auth_token: auth_token)
    end

    before { allow_any_instance_of(DebateNotifier).to receive(:notify_about_votes) }
    before { post :create, params: { id: new_answer_id } }

    it 'returns 201 response status' do
      expect(response).to have_http_status(201)
    end

    it 'returns empty body' do
      expect(response.body).to be_blank
    end
  end
end
