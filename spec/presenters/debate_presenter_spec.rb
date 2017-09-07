require 'rails_helper'

describe DebatePresenter do
  let(:debate) do
    OpenStruct.new(positive_count: 5,
                   negative_count: 45,
                   neutral_count: 10,
                   votes_count: 60)
  end

  subject { described_class.new(debate) }

  describe '#positive_count_with_person' do
    it 'returns an amount of people voted for a positive answer' do
      debate = OpenStruct.new(positive_count: 1)
      expect(described_class.new(debate).positive_count_with_person).to eq('1 person')
    end
  end

  describe '#negative_count_with_person' do
    it 'returns an amount of people voted for a negative answer' do
      expect(subject.negative_count_with_person).to eq('45 people')
    end
  end

  describe '#positive_percent' do
    it 'returns 0% for no votes' do
      debate.positive_count = 0
      expect(described_class.new(debate).positive_percent).to eq('0%')
    end

    it 'returns an amount in percent of people voted for a positive answer' do
      expect(subject.positive_percent).to eq('10%')
    end
  end

  describe '#negative_percent' do
    it 'returns 0% for no votes' do
      debate.negative_count = 0
      expect(described_class.new(debate).negative_percent).to eq('0%')
    end

    it 'returns an amount in percent of people voted for a negative answer' do
      expect(subject.negative_percent).to eq('90%')
    end
  end

  describe '#votes_count' do
    it 'counts positive and negative votes only' do
      expect(subject.votes_count).to eq(debate.positive_count + debate.negative_count + debate.neutral_count)
    end
  end

  describe '#last_comments_json' do
    let(:debate) { create(:debate) }
    let(:users) do
      5.times.map { create(:user, auth_token: debate.create_auth_token!) }
    end
    let(:json) { subject.last_comments_json(count: number_of_comments) }
    let(:parsed_json) { JSON.parse(json) }
    let(:number_of_comments) { rand(1..20) }

    before do
      20.times do
        create(
          :comment,
          user: users.sample,
          debate: debate,
          status: :accepted
        )
      end
    end

    it 'is valid json' do
      expect { parsed_json }.not_to raise_error
    end

    it 'is list of serialized comments' do
      expect(parsed_json).to all(look_like_comment_json)
    end

    it 'serializes specified number of comments' do
      expect(parsed_json.count).to eq(number_of_comments)
    end
  end

  def look_like_comment_json
    match(
      "id"                             => be_a_kind_of(Integer),
      "content"                        => be_a_kind_of(String),
      "full_name"                      => be_a_kind_of(String),
      "created_at"                     => be_a_kind_of(Integer),
      "user_initials_background_color" => be_a_kind_of(String),
      "user_initials"                  => be_a_kind_of(String),
      "user_id"                        => be_a_kind_of(Integer),
      "status"                         => be_a_kind_of(String)
    )
  end
end
