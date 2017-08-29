require 'rails_helper'

describe Api::CommentsController do
  let(:params) { { text: 'comment_text', username: 'username' } }
  before(:all) do
    Timecop.freeze(Time.local(2017, 8, 5, 10, 10, 10))
  end

  after do
    Timecop.return
  end

  context 'when correct auth_token was given' do
    let(:debate) { create(:debate) }
    let(:auth_token) { debate.auth_tokens.create }
    let!(:mobile_user) { create(:mobile_user, auth_token: auth_token, first_name: 'John', last_name: 'Doe') }

    before do
      request.env['HTTP_AUTHORIZATION'] = auth_token.value
    end
    describe '#create' do

      it 'executes the comment maker service' do
        expect(CommentMaker).to receive(:perform).with(
          hash_including({
                           debate: debate,
                           user: mobile_user,
                           params: { content: 'comment_text' }
                         })
        )

        post :create, params: params
      end
    end

    describe '#index' do
      context 'when comments are created and have status active' do
        let(:expected_list) do
          [{ "id" => comment.id,
             "content" => comment.content,
             "full_name" => mobile_user.full_name,
             "created_at" => Time.now.to_i * 1000,
             "user_initials_background_color" => mobile_user.initials_background_color,
             "user_initials" => mobile_user.initials,
             "user_id" => mobile_user.id,
             "status" => comment.status }]
        end

        let!(:comment) { create(:comment, user: mobile_user, debate: debate, status: :accepted) }

        before do
          request.env['HTTP_AUTHORIZATION'] = auth_token.value
        end

        it 'retrieve valid status' do
          get :index
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)).to eq(expected_list)
        end
      end

      context 'when comments are not created' do
        it 'retrieve valid status and empty array of comments' do
          get :index
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)).to eq([])
        end
      end

      context 'when comments are created, but status is pending' do
        before do
          FactoryGirl.create(:comment, user: mobile_user, debate: debate)
          FactoryGirl.create(:comment, user: mobile_user, debate: debate)
          request.env['HTTP_AUTHORIZATION'] = auth_token.value
        end
        it 'retrieve valid status and empty array of comments' do
          get :index
          expect(response.status).to eq(200)
          expect(JSON.parse(response.body)).to eq([])
        end
      end
    end
  end

  context 'when auth_token was not given' do
    it 'does not execute any of the services' do
      expect(CommentMaker).not_to receive(:perform)

      post :create, params: params

      expect(response.status).to eq(401)
    end
  end
end
