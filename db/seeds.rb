def create_users
  p 'Creating god user'
  User.create(
    name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: 'burguer@gmail.com',
    password: 'admin admin admin',
    password_confirmation: 'admin admin admin',
    role: :god)

  p 'Creating users'
  10.times do
    User.create(
      name: Faker::Name.first_name,
      last_name: Faker::Name.last_name,
      email: Faker::Internet.email,
      password: 'user user user',
      password_confirmation: 'user user user',
      role: :user)
  end

  p "#{User.count} users are stored."
end

def create_posts
  p 'Creating posts'
  posts = []
  users_ids = User.ids
  50.times do
    posts << {
      title: Faker::Lorem.sentence,
      body: Faker::Lorem.paragraph,
      status: Post.statuses.values[rand(2)],
      user_id: users_ids.sample,
      created_at: DateTime.now,
      updated_at: DateTime.now}
  end
  Post.insert_all(posts)
  p "#{Post.count} posts are stored."
end

create_users
create_posts
