FactoryGirl.define do
  factory :note do
    title { Faker::Lorem.words([3, 4, 5].sample).join(" ") }
    body { Faker::Lorem.paragraph }
  end
end
