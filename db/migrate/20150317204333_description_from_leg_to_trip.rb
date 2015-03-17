class DescriptionFromLegToTrip < ActiveRecord::Migration
  def change
    remove_column :legs, :description, :string
    add_column :trips, :description, :string
  end
end
