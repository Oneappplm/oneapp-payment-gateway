class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :user_role
end
