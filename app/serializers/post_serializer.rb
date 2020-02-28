class PostSerializer < ActiveModel::Serializer
  attributes :id, :body, :created_at, :status, :title, :user

  def user
    instance_options[:without_serializer] ? object.user : UserSerializer.new(object.user, without_serializer: true)
  end
end
