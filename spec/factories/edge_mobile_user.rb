FactoryGirl.define do
  factory :edge_mobile_user, class: 'Edge::MobileUser' do
    auth_token
  end
end
