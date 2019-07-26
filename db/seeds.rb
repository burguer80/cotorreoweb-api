# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create(email: 'burguer@gmail.com', password: 'admin admin admin', password_confirmation: 'admin admin admin')

Post.create(title: 'Post 1', body: 'Body text')
Post.create(title: 'Post 2', body: 'Body text')
Post.create(title: 'Post 3', body: 'Body text')