class PostSerializer
  include FastJsonapi::ObjectSerializer
  set_type :posts
  attributes :body, :title, :status, :user
end
