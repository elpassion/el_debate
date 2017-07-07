require 'rails_helper'

describe Api::CommentsController do
  describe '#create' do
    let(:params) {{ text: 'comment_text', username: 'username' }}

    context 'when correct auth_token was given' do
      let(:debate)        { create(:debate) }
      let(:auth_token)    { debate.auth_tokens.create }
      let!(:mobile_user)  { create(:mobile_user, auth_token: auth_token)}
      before do
        request.env['HTTP_AUTHORIZATION'] = auth_token.value
      end

      it 'executes the comment maker service' do
        expect(CommentMaker).to receive(:perform).with(
          hash_including({
            debate:         debate,
            user:           mobile_user,
            comment_class:  MobileComment,
            params:         { content: 'comment_text' }
          })
        )

        post :create, params: params
      end
    end

    context 'when auth_token was not given' do
      it 'does not execute any of the services' do
        expect(CommentMaker).not_to receive(:perform)

        post :create, params: params
      end
    end
  end
end