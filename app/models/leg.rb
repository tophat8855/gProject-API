class Leg < ActiveRecord::Base
  belongs_to :trip
  belongs_to :user
  validates :type, :start_location, :end_location, :distance, presence: true
end
