class LegSerializer < ActiveModel::Serializer
  attributes :id, :mode, :start_location, :end_location, :distance, :emissions, :created_at
end
