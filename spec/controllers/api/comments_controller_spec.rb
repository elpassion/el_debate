require 'rails_helper'

describe Api::CommentsController do
  let(:params) { { text: 'comment_text', username: 'username' } }
  let(:debate) { create(:debate) }
  let(:auth_token) { create(:auth_token, debate: debate) }
  let(:token_value) { auth_token.value }
  let!(:user) { create(:user, auth_token: auth_token, first_name: 'John', last_name: 'Doe') }

  before do
    request.env['HTTP_AUTHORIZATION'] = token_value
  end

  describe '#create' do
    subject do
      post :create, params: params
      response
    end

    let(:json_response) { JSON.parse(subject.body) }

    it 'executes the comment maker service' do
      expect(CommentMaker).to receive(:perform).with(
        hash_including({
                         debate: debate,
                         user: user,
                         params: { content: 'comment_text' }
                       })
      )

      subject
    end

    it 'renders status created' do
      expect(subject).to have_http_status(:created)
    end

    it 'renders json with created comment' do
      expect(json_response).to look_like_comment_json
    end

    context 'when auth_token was not given' do
      let(:token_value) { '' }

      it 'does not execute any of the services' do
        expect(CommentMaker).not_to receive(:perform)

        expect(subject).to have_http_status(:unauthorized)
      end
    end

    context 'when debate is closed' do
      let(:debate) { create(:debate, :closed_debate) }

      it 'returns forbidden status with error message on comments create' do
        expect(subject).to have_http_status(:forbidden)
        expect(json_response).to include('error' => 'Debate is closed')
      end
    end
  end

  describe '#index' do
    subject do
      get :index
      response
    end

    let(:json_response) { JSON.parse(subject.body) }

    it 'returns debate status in json' do
      expect(json_response).to include('debate_closed' => false)
    end

    it 'has 200 ok http status' do
      expect(subject).to have_http_status(:ok)
    end

    context 'when comments are created and have status accepted' do
      before { create(:comment, user: user, debate: debate, status: :accepted) }

      it 'returns comments list in json' do
        expect(json_response).to include('comments' => all(look_like_comment_json))
      end
    end

    context 'when comments are not created' do
      it 'returns empty comments list' do
        expect(json_response).to include('comments' => [])
      end
    end

    context 'when comments are created, but status is pending' do
      before do
        create_list(:comment, 5, user: user, debate: debate, status: :pending)
      end

      it 'retrieve empty array of comments' do
        expect(json_response).to include("comments" => [])
      end
    end

    context 'when debate is closed' do
      let(:debate) { create(:debate, :closed_debate, :with_comments, comments_status: :accepted) }

      it 'returns comment list' do
        expect(json_response).to include('comments' => all(look_like_comment_json))
      end

      it 'returns debate status in json' do
        expect(json_response).to include('debate_closed' => true)
      end
    end

    describe 'paginated result' do
      let!(:comments) { create_list(:comment, all_count, user: user, debate: debate, status: :accepted) }
      let(:all_count) { 10 }

      context 'when limit given' do
        subject do
          get :index, params: { limit: limit }
          response
        end

        let(:limit) { 5 }

        it 'retrieves given number of comments' do
          expect(json_response['comments'].count).to eq(limit)
        end
      end

      context 'when limit not given' do
        it 'retrieves 10 comments' do
          expect(json_response['comments'].count).to eq(10)
        end
      end

      context 'when position given' do
        subject do
          get :index, params: { position: position }
          response
        end

        let(:position) { comments.map(&:id).sort[2..8].sample }

        it 'retrieves comments from given position' do
          expect(json_response['comments']).to all(include_id_lower_than_or_equal(position))
        end
      end

      context 'when position not given' do
        let(:newest_id) { comments.map(&:id).max }

        it 'retrieves comments from newest' do
          expect(json_response['comments']).to all(include_id_lower_than_or_equal(newest_id))
        end
      end
    end
  end
end
