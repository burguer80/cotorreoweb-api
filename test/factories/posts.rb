FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    status { Post.statuses.keys[rand(2)] }
  end
end
