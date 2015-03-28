class BusStopData < ActiveRecord::Migration
  def change
    add_column :legs, :direction, :string
    add_column :legs, :route, :string
  end
end
