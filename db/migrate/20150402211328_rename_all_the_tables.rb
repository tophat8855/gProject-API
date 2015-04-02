class RenameAllTheTables < ActiveRecord::Migration
  def change
    rename_table :bus_route, :bus_routes
    rename_table :pattern, :patterns
    rename_table :patternstop, :pattern_stops
    rename_table :stop, :stops
  end
end
