class CsvTableMania < ActiveRecord::Migration
  def change
    create_table :route do |t|
      t.string :sch_routeid
      t.string :rtd_agencyrouteid
    end

    create_table :pattern do |t|
      t.string :sch_patternid
      t.string :sch_routeid
    end

    create_table :patternstop do |t|
      t.string :sch_stoppointseqno
      t.string :sch_patternid
      t.string :cpt_stoppointid
    end

    create_table :stop do |t|
      t.string :cpt_stoppointid
      t.string :sp_longitude
      t.string :sp_latitude
    end
  end
end
