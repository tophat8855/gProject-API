class Trip < ActiveRecord::Base
  has_many :legs
end
