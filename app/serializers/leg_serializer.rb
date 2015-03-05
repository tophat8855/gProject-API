class LegSerializer < ActiveModel::Serializer
  attributes :id, :type, :start_location, :end_location, :distance, :emissions, :description
end
