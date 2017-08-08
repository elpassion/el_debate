require 'rails_helper'

RSpec.shared_examples "comments example" do

  it "returns valid hash" do
    expect(subject).to eq(expected_hash)
  end
end


describe ActionCable::GetComments do
  subject { described_class.new(debate.id).to_h }

  let(:debate) { create(:debate) }
  let(:user) { create(:mobile_user, first_name: 'John', last_name: 'Doe') }


  before(:all) do
    Timecop.freeze(Time.local(2017, 8, 5, 0, 0, 0))
  end

  after do
    Timecop.return
  end

  context 'when comments are created' do
    let(:expected_hash) do
      [{ :content => "content comment 1",
         :full_name => 'John Doe',
         :created_at => Time.now.to_i,
         :user_initials_background_color => user.initials_background_color,
         :user_initials => 'JD' },
       { :content => "content comment 2",
         :full_name => 'John Doe',
         :created_at => Time.now.to_i,
         :user_initials_background_color => user.initials_background_color,
         :user_initials => 'JD' }]
    end

    before do
      FactoryGirl.create(:comment, user: user, content: 'content comment 1', debate: debate)
      FactoryGirl.create(:comment, user: user, content: 'content comment 2', debate: debate)
    end

    include_examples "comments example"
  end

  context 'when comments are not created' do
    let(:expected_hash) {[]}

    include_examples "comments example"
  end
end
