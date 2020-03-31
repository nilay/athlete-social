FactoryGirl.define do
  factory :comment do
    association :commentable, factory: :post
  end
end
