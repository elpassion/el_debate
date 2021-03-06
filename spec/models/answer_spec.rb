require 'rails_helper'

describe Answer do
  describe '#default_answers' do
    def answer_by_type(answer_type)
      ->(answer) { answer.answer_type_key == answer_type }
    end

    let(:default_answers) { Answer.default_answers }

    it 'validates answer type' do
      expect { build(:answer, answer_type: :invalid_answer) }.to raise_error(ArgumentError)
    end

    it 'validates debate existence' do
      answer = build(:answer, debate: nil)
      expect(answer).not_to be_valid
      expect(answer.errors[:debate]).to include('must exist')
    end

    it 'validates value presence' do
      answer = build(:answer, value: nil)
      expect(answer).not_to be_valid
      expect(answer.errors[:value]).to include("can't be blank")
    end

    it 'creates one positive answer' do
      positive_answers_count = default_answers.count(&answer_by_type(:positive))
      expect(positive_answers_count).to eq(1)
    end

    it 'creates one neutral answer' do
      neutral_answers_count = default_answers.count(&answer_by_type(:neutral))
      expect(neutral_answers_count).to eq(1)
    end

    it 'creates one negative answer' do
      negative_answers_count = default_answers.count(&answer_by_type(:negative))
      expect(negative_answers_count).to eq(1)
    end

    context 'positive answer' do
      it 'has value "Yes"' do
        positive_answer = default_answers.find(&answer_by_type(:positive))
        expect(positive_answer.value).to eq('Yes')
      end
    end

    context 'neutral answer' do
      it 'has value "Undecided"' do
        neutral_answer = default_answers.find(&answer_by_type(:neutral))
        expect(neutral_answer.value).to eq('Undecided')
      end
    end

    context 'negative answer' do
      it 'has value "No"' do
        negative_answer = default_answers.find(&answer_by_type(:negative))
        expect(negative_answer.value).to eq('No')
      end
    end
  end

  describe '#answer_type_key' do
    before do
      allow_any_instance_of(DebateMaker).to receive(:add_default_answers).and_return([])
    end

    it 'returns ":positive" type symbol for positive answer' do
      answer = create(:answer, :positive_answer)
      expect(answer.answer_type_key).to eq(:positive)
    end

    it 'returns ":neutral" type symbol for neutral answer' do
      answer = create(:answer, :neutral_answer)
      expect(answer.answer_type_key).to eq(:neutral)
    end

    it 'retuns ":negative" type symbol for negative answer' do
      answer = create(:answer, :negative_answer)
      expect(answer.answer_type_key).to eq(:negative)
    end
  end

end
