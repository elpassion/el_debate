require 'rails_helper'

describe PaginatedComments do
  let(:debate) { create(:debate) }
  let(:start_at) { nil }
  let(:limit) { 3 }
  let(:comment_count) { 10 }
  let(:params) { { limit: limit, position: start_at } }
  let(:default_count) { 10 }

  before { create_list(:comment, comment_count, debate: debate, status: :accepted) }

  describe '#call' do
    subject do
      described_class
        .new(comments_relation: debate.retrieve_comments,
             direction: :backward,
             params: params)
        .call
    end

    it 'returns specified number of comments' do
      expect(subject[:comments].count).to eq(limit)
    end

    it 'returns next position' do
      expect(subject).to include(next_position: a_kind_of(Integer))
    end

    it 'returns serialized comments' do
      expect(subject[:comments].map(&:stringify_keys)).to all(look_like_comment_json)
    end

    context 'when limit not specified' do
      let(:limit) { nil }

      it 'returns default number of comments' do
        expect(subject[:comments].count).to eq(default_count)
      end
    end

    context 'when limit is not a number' do
      let(:limit) { 'NotANumber' }

      it 'returns default number of comments' do
        expect(subject[:comments].count).to eq(default_count)
      end
    end

    context 'when position not specified' do
      it 'returns next position' do
        expect(subject).to include(next_position: a_kind_of(Integer))
      end

      it 'returns comments list' do
        expect(subject[:comments]).not_to be_empty
      end
    end

    context 'when position is not a number' do
      it 'returns next position' do
        expect(subject).to include(next_position: a_kind_of(Integer))
      end

      it 'returns comments list' do
        expect(subject[:comments]).not_to be_empty
      end
    end
  end

end
