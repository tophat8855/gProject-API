class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :user
      t.date :date

      t.timestamps
    end
  end
end
