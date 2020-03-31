FactoryGirl.define do
  factory :fan do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { "#{first_name.downcase}.#{last_name.downcase}@challah.me" }
    password "test123"
    password_confirmation "test123"
  end
end
