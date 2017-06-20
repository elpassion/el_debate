FactoryGirl.define do
  factory :comment do
    debate
    content { FFaker::HipsterIpsum.sentence }
  end

  factory :slack_comment, parent: :comment, class: 'SlackComment' do
    user { slack_user }
  end

  factory :mobile_comment, parent: :comment, class: 'MobileComment' do
    user { mobile_user }
  end
end
