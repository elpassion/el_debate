require 'rails_helper'

describe Debate, type: :model do
  it 'is valid' do
    debate = build(:debate)
    expect(debate).to be_valid
  end

  it 'validates topic presence' do
    debate = build(:debate, topic: '')
    expect(debate).not_to be_valid
  end

  it 'is opened by default' do
    debate = create(:debate)
    expect(debate.is_closed?).not_to be
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
  end

  describe "#slug" do
    let(:debate) { create(:debate) }

    it "assigns slug after object creation" do
      expect(debate.slug).not_to be_nil
    end
  end

  describe '#open' do
    let(:notifier) { double('DebateNotifier') }
    let(:debate) { create(:debate, :closed_debate) }

    it 'is opening a closed debate' do
      expect{ debate.open }.to change{ debate.is_closed? }.from(true).to(false)
    end
  end

  describe '#close' do
    let(:debate) { create(:debate) }

    it 'is closing an opened debate' do
      expect{ debate.close }.to change{ debate.is_closed? }.from(false).to(true)
    end
  end

  describe '#closed?' do
    let(:debate) { create(:debate) }

    it 'is opened by default' do
      expect(debate.is_closed?).not_to be
    end

    it 'might be closed manually' do
      debate.close
      expect(debate.is_closed?).to be
    end
  end

  describe 'counter class methods' do
    let(:debate) { create(:debate) }
    let(:positive_vote!) { create(:vote, answer: debate.positive_answer) }
    let(:negative_vote!) { create(:vote, answer: debate.negative_answer) }
    let(:neutral_vote!) { create(:vote, answer: debate.neutral_answer) }

    describe '#positive_count' do
      it 'returns an amount of votes given for positive answer' do
        positive_vote!
        expect(debate.positive_count).to eq 1
      end
    end

    describe '#negative_count' do
      it 'returns an amount of votes given for negative answer' do
        negative_vote!
        expect(debate.negative_count).to eq 1
      end
    end

    describe '#neutral_count' do
      it 'returns an amount of votes given for neutral answer' do
        neutral_vote!
        expect(debate.neutral_count).to eq 1
      end
    end
  end

  describe ".opened_for_channel!" do
    context "there is an open debate for a given channel" do
      let!(:debate) do
        create(:debate, channel_name: 'channel_name')
      end

      it "returns it" do
        expect(Debate.opened_for_channel!('channel_name')).to eq debate
      end
    end

    context "there is no open debate for a given channel" do
      it "raises an error" do
        expect {
          Debate.opened_for_channel!('channel_name')
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end

