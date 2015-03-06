class Trip < ActiveRecord::Base
  has_many :legs
  belongs_to :user
end
