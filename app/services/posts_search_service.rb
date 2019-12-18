class PostsSearchService
  def self.search(curr_posts, search)
    curr_posts.where('title ILIKE ?', "%#{search}%")
  end
end