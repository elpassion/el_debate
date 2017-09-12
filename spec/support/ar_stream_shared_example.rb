RSpec.shared_examples "ar_stream_shared_example" do
  it 'returns specified number of records' do
    expect(subject.count).to eq records_count
  end

  it 'changes stream position' do
    expect { subject }.to(change { comment_stream.position })
  end

  context 'subsequent call' do
    it 'returns different results than first' do
      comments  = comment_stream.next(records_count)
      comments2 = comment_stream.next(records_count)

      expect(comments2).not_to eq(comments)
    end

    context 'when no more records available' do
      before { comment_stream.next(records_count) }

      let(:records_count) { all_count }

      it 'returns empty array' do
        comments = comment_stream.next(records_count)
        expect(comments).to be_empty
      end
    end
  end
end