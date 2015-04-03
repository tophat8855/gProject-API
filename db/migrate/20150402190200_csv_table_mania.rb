class CsvTableMania < ActiveRecord::Migration
  def change
    create_table :bus_routes do |t|
      # t.string :sch_routeid
      t.string :name
    end

    create_table :patterns do |t|
      # t.string :sch_patternid
      t.string :direction
      t.integer :bus_route_id
    end

    create_table :pattern_stops do |t|
      t.string :seq_no
      t.integer :pattern_id
      t.integer :stop_id

      # t.string :sch_patternid
      # t.string :cpt_stoppointid
    end

    create_table :stops do |t|
      # t.string :cpt_stoppointid
      t.float :longitude
      t.float :latitude
    end
  end
end
