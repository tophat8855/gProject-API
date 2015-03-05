class CreateLegs < ActiveRecord::Migration
  def change
    create_table :legs do |t|
      t.string :type
      t.string :start_location
      t.string :end_location
      t.float :distance
      t.float :emissions
      t.string :description

      t.timestamps
    end
  end
end
