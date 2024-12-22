# db/seeds.rb
Article.delete_all
ArticleUser.delete_all
Comment.delete_all
Reaction.delete_all
User.delete_all
Section.delete_all

# Create users with hashed passwords
user1 = User.create!(username: 'alice', email: 'alice@example.com', password: 'password', role: 'Editor')
user2 = User.create!(username: 'bob', email: 'bob@example.com', password: 'password', role: 'Viewer')
user3 = User.create!(username: 'charlie', email: 'charlie@example.com', password: 'password', role: 'Viewer')
user4 = User.create!(username: 'Nymeria', email:'nymeria@mail.com', password: 'wolf1234', role:'Reporter')
user5 = User.create!(username: 'Ghost', email:'ghost@mail.com', password: 'wolf435', role:'Reporter')

# Create sections
section1 = Section.create!(name: 'Technology', dimensions: 'Width: 800px, Height: 600px')
section2 = Section.create!(name: 'Health', dimensions: 'Width: 800px, Height: 600px')

# Create articles
article1 = Article.create!(
  title: 'The Future of AI',
  content: 'This article discusses the future of AI in various industries.',
  media_url: 'https://example.com/media/future-of-ai.jpg',
  status: 'Published',
  section: section1,
  primary_contributor: user4,
  approved_by: user1
)

article2 = Article.create!(
  title: 'Healthy Living Tips',
  content: 'This article shares tips on living a healthier life.',
  status: 'Pending',
  section: section2,
  primary_contributor: user5
)

# Create article_users to link articles with users and assign roles

ArticleUser.create!(article_id: Article.first.id, user_id: user5.id, role: "Contributor")

#

# Create comments
comment1 = Comment.create!(content: 'This is an insightful article about AI.', user: user2, article: article1)
comment2 = Comment.create!(content: 'I disagree with some points, but overall a great read.', user: user1, article: article1, parent_comment: comment1)
comment3 = Comment.create!(content: 'Thanks for the tips!', user: user3, article: article2)

# Create reactions
Reaction.create!(reaction_type: 'Like', reactable: article1, user: user2)
Reaction.create!(reaction_type: 'Love', reactable: comment1, user: user3)

puts "Seed data created successfully!"
