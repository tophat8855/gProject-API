class Renaming < ActiveRecord::Migration
  def change
    rename_table :route, :bus_route
  end
end
