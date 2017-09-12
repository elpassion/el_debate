require 'rails_helper'

describe ARStream::Backward do
  before { create_list(:comment, all_count) }

  let(:all_count)      { 10 }
  let(:comment_stream) { described_class.new(Comment, start_at: start) }
  let(:start)          { nil }
  let(:sorted_ids)     { Comment.order(id: :desc).pluck(:id) }

  describe '#next' do
    subject { comment_stream.next(records_count) }

    let(:records_count) { 3 }

    include_examples "ar_stream_shared_example"

    it 'returns records sorted by id descending' do
      expect(subject).to eq(subject.sort_by(&:id).reverse)
    end

    it 'sets position to id before last element' do
      subject
      expect(comment_stream.position).to eq(subject.last.id - 1)
    end

    context 'when no records available' do
      let(:start) { sorted_ids.last - 1 }

      it 'returns empty array' do
        expect(subject).to be_empty
      end
    end

    context 'when stream started with id provided' do
      let(:start) { sorted_ids[3..6].sample } # lets take something from the middle

      it 'returns records with id lower or equal to provided' do
        expect(subject.map(&:id)).to all(be <= start)
      end
    end
  end
end
