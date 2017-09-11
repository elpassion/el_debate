require 'rails_helper'

describe PaginatedComments do

  let(:user) { create(:user) }
  let(:debate) { create(:debate) }
  let(:start_at) { nil }
  let(:limit) { 3 }
  let(:comment_count) { 10 }
  let(:sorted_ids)     { Comment.order(id: :desc).pluck(:id) }
  let(:params) { {limit: limit, position: start_at} }

  subject { described_class.new(comments_relation: debate.retrieve_comments,
                                direction: :backward,
                                params: params).to_h }

  context 'When comments are created' do
    before { create_list(:comment, comment_count, debate: debate, status: :accepted) }

    it 'returns list of comments with limit' do
      expect(subject[:comments].count).to eq(limit)
      expect(subject).to include(:next_position => sorted_ids.first - limit)
    end
  end

  context 'when everything was shown' do
    let(:start_at) { sorted_ids.last }

    it 'returns empty array' do
      expect(subject[:comments]).to be_empty
    end
  end
end
