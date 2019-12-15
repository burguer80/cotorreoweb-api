FactoryBot.define do
  factory :post do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    status { Post.statuses.keys[rand(2)] }
  end

  factory :published_post, class: 'Post' do
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.paragraph }
    status { :published }
    user
  end
end
