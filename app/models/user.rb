class User < ActiveRecord::Base
  has_many :trips
  has_many :legs, through: :trips
  validates :email, presence: true, uniqueness: true, confirmation: true
  has_secure_password
end
