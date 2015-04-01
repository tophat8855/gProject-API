class UserSerializer < ActiveModel::Serializer
  attributes :id, :email#, :authentication_token
  has_many :legs, except: [:user]
end
