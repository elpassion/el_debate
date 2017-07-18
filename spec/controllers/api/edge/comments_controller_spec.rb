require 'rails_helper'

describe Api::Edge::CommentsController do
  describe '#create' do
    context 'when mobile user does not have the first name and the last name' do
      let(:debate)        { create(:debate) }
      let(:auth_token)    { debate.auth_tokens.create }
      let!(:mobile_user)  { create(:edge_mobile_user, auth_token: auth_token)}
      before do
        request.env['HTTP_AUTHORIZATION'] = auth_token.value
        post :create, params: params
      end

      context 'and the first name is not included to params' do
        let(:params) {{ text: 'comment_text' }}

        it 'returns error message' do
          json_response = JSON.parse(response.body)
          expect(json_response).to include('error')
          expect(json_response['error']).to eq 'param is missing or the value is empty: first_name'
        end
      end

      context 'and the first name and the last name is included to params' do
        let(:params) {{ text: 'comment_text', first_name: 'First Name', last_name: 'Last Name' }}
        it 'returns status created' do
          expect(response.status).to eq 201
        end
      end
    end

    context 'when correct auth_token was given' do
      let(:debate)        { create(:debate) }
      let(:auth_token)    { debate.auth_tokens.create }
      let!(:mobile_user)  { create(:edge_mobile_user, auth_token: auth_token)}
      let(:params) {{ text: 'comment_text', first_name: 'First Name', last_name: 'Last Name' }}
      before do
        request.env['HTTP_AUTHORIZATION'] = auth_token.value
      end

      it 'executes the comment maker service' do
        expect(CommentMaker).to receive(:perform).with(
          hash_including({
            debate: debate,
            user:   mobile_user,
            params: { content: 'comment_text' }
          })
        )

        post :create, params: params
      end
    end

    context 'when auth_token was not given' do
      let(:params) {{ text: 'comment_text', first_name: 'First Name', last_name: 'Last Name' }}
      it 'does not execute any of the services' do
        expect(CommentMaker).not_to receive(:perform)

        post :create, params: params
      end
    end
  end
end
