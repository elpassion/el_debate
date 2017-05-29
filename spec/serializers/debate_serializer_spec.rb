require 'rails_helper'

describe DebateSerializer do
  let(:debate) { create(:debate) }
  let(:auth_token) { debate.auth_tokens.create }
  let(:serialized_debate) { described_class.new(debate, auth_token).to_json }

  context 'when there is no previous vote' do
    it 'returns nil for last_answer_id key if there is no previous vote' do
      expect(serialized_debate[:last_answer_id]).to be_nil
    end
  end

  context 'when previous vote exists' do
    let(:answer) { debate.answers.sample }

    before do
      create(:vote, answer: answer, auth_token: auth_token)
    end

    it 'returns last_answer_id if previous vote exists' do
      expect(serialized_debate[:last_answer_id]).to eq(answer.id)
    end
  end
end
