class AddDateToLegs < ActiveRecord::Migration
  def change
    add_column :legs, :date, :date
  end
end
