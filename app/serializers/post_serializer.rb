class PostSerializer
  include FastJsonapi::ObjectSerializer
  set_type :posts
  attributes :body, :created_at, :status, :title, :user
end
