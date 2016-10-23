require 'rails_helper'

describe Debate, type: :model do
  it 'validates topic presence' do
    debate = build(:debate, topic: '')
    expect(debate).not_to be_valid
    expect(debate.errors[:topic]).to include("can't be blank")
  end

  it 'deletes answers when destroyed' do
    debate = create(:debate)
    expect { debate.destroy }.to change { Answer.count }
  end

  it 'deletes debate auth tokens when destroyed' do
    debate = create(:debate)
    create(:auth_token, debate: debate)
    expect { debate.destroy }.to change { AuthToken.count }
  end


  describe '#code' do
    let(:debate) { create(:debate) }

    it 'has 5 characters' do
      expect(debate.code.length).to eq(5)
    end

    it 'has only digits' do
      expect(debate.code).to match(/\A\d+\z/)
    end

    it 'is generated when model created' do
      expect(debate.code).not_to be_blank
    end

    it 'cannot be changed' do
      code = debate.code
      debate.update! code: 12345
      debate.reload

      expect(debate.code).to eq(code)
    end

    it 'persists code between model updates' do
      code = debate.code
      debate.update! topic: FFaker::HipsterIpsum.sentence
      expect(debate.code).to eq(code)
    end

    it 'is unique' do
      codes = [12345, 12345, 54321]
      allow_any_instance_of(Debate).to receive(:generate_code).and_return(*codes)

      debate1 = create(:debate)
      debate2 = create(:debate)

      expect(debate1.code).not_to eq(debate2.code)
    end
  end
end
