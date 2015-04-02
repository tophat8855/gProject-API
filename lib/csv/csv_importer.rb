require 'csv'

class CsvImporter
  def initialize(route_path, pattern_path, pattern_stop_path, stop_path)
    @route_csv = CSV.read(route_path)
    @pattern_csv = CSV.read(pattern_path)
    @patternstop_csv = CSV.read(pattern_stop_path)
    @stop_csv = CSV.read(stop_path)

    @route_csv.shift
    @pattern_csv.shift
    @patternstop_csv.shift
    @stop_csv.shift
  end

  def import
    @route_csv.each do |line|
      BusRoute.create(
        :sch_routeid => line[0],
        :rtd_agencyrouteid => line[10]
      )
    end

    @pattern_csv.each do |line|
      Pattern.create(
        :sch_patternid => line[0],
        :sch_routeid => line[6]
      )
    end

    @patternstop_csv.each do |line|
      PatternStop.create(
        :sch_stoppointseqno => line[1],
        :sch_patternid => line[5],
        :cpt_stoppointid => line[7]
      )
    end

    @stop_csv.each do |line|
      Stop.create(
        :cpt_stoppointid => line[0],
        :sp_longitude => line[6],
        :sp_latitude => line[8]
      )
    end
  end
end
