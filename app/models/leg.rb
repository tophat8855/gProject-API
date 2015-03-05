class Leg < ActiveRecord::Base
  belong_to :trip
  validates :type, :start_location, :end_location, :distance, presence: true
end
