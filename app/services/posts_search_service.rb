class PostsSearchService
  def self.search(curr_posts, search)
    curr_posts.where('title ilike ?', "%#{search}%")
  end
end