FactoryGirl.define do
  factory :question do
    questioner_type "athlete"
    text "What does it feel like to be a hero?"

    questioner_id 1

    trait :with_athlete do
      before(:create) do |question|
        question.questioner_type = "athlete"
        question.questioner_id = create(:athlete).id
      end
    end

    trait :with_reactions do
      after(:create) do |question|
        create :post, parent_type: "Question", parent_id: question.id, status: :complete, content_type: "video"
      end
    end
  end
end
