FactoryGirl.define do
  factory :reaction, class: Post do
    association :athlete
    
  end
end
