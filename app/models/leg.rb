class Leg < ActiveRecord::Base
  belongs_to :user
  validates :mode, :start_location, :end_location, :distance, :emissions, presence: true
end
