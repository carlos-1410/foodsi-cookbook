FactoryBot.define do
  factory :category do
    name { Faker::Food.dish }
    group { Category.groups.keys.sample }
  end
end
