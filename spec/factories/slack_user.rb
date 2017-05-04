FactoryGirl.define do
  factory :slack_user, class: Slack::User do
    sequence(:name) { |n| "Foooo#{n}" }
    sequence(:slack_id) { |n| "test_slack_id#{n}" }
  end
end
