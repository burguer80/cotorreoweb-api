class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :last_name, :email
end
