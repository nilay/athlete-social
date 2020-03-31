FactoryGirl.define do
  factory :post do
    trait :completed do
      status "complete"
    end

    trait :pending do
      status "pending"
    end

    trait :video do
      content_type "video"
    end

    trait :image do
      content_type "image"
    end

    association :athlete

    trait :with_reactions do
      after(:create) do |post|
        athlete = create :athlete
        create :post, parent_type: "Post", parent_id: post.id, status: :complete, content_type: "video", athlete_id: athlete.id
      end
    end

    trait :with_comments do
      after(:create) do |post|
        Comment.create(text: "Test Comment", commentable_id: post.id, commentable_type: "Post")
      end
    end

    trait :with_tags do
      before(:create) do |post|
        athlete1 = create :athlete
        athlete2 = create :athlete
        post.athletes_tagged_list = [athlete1.id.to_s, athlete2.id.to_s]
      end
    end
  end
end
