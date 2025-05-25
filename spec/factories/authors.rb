FactoryBot.define do
  factory :author do
    name { Faker::Name.name }
    bio { Faker::Lorem.paragraph }
    fb { Faker::Internet.username }
    ig { Faker::Internet.username }
    user
  end
end
