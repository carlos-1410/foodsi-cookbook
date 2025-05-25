FactoryBot.define do
  factory :user do
    nickname { Faker::Internet.username }

    trait :with_author do
      after(:create) do |user|
        create(:author, user: user)
      end
    end
  end
end
