class Pattern < ActiveRecord::Base
  belongs_to :bus_route
  has_many :pattern_stop
end
