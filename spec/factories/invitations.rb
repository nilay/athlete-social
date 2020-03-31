FactoryGirl.define do
  factory :invitation do
    inviter_type "athlete"
    inviter_id 1
    association :invitee, factory: :athlete
    email "test@example.com"
  end
end
