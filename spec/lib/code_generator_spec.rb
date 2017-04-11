require 'rails_helper'
require 'code_generator'

describe CodeGenerator do
  let(:charset) { ('a'..'d').to_a }
  let(:length)  { 5 }
  subject { described_class.new(charset, length) }

  it 'sets code with provided length' do
    expect(subject.generate.length).to be length
  end

  it 'sets code from provided set of characters only' do
    code_characters = subject.generate.split('')
    expect(Set.new(code_characters) - charset).to be_empty
  end

  context 'with predicate block' do
    let(:retries) { 3 }

    it 'breaks after provided number of retries' do
      expect { subject.generate(num_retries: retries) { |code| false } }
        .to raise_error(described_class::NumRetriesExceeded)
    end
  end
end
