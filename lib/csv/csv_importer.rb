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
      bus_route = BusRoute.new do |route|
        route.id = line[0]
        route.name = line[10]
      end
      bus_route.save
      p bus_route
    end
    p "routes finished"

    @pattern_csv.each do |line|
      pattern = Pattern.new do |pat|
        pat.id = line[0]
        pat.bus_route_id = line[6]
        pat.direction = line[9].strip
        p
      end
      pattern.save
      p pattern
    end
    p "patterns finished"

    @patternstop_csv.each do |line|
      pstop = PatternStop.new do |ps|
        ps.id = line[0]
        ps.seq_no = line[1]
        ps.pattern_id = line[5]
        ps.stop_id = line[7]
      end
      pstop.save
      p pstop
    end
    p "pattern stops finished"

    @stop_csv.each do |line|
      stop = Stop.new do |s|
        s.id = line[0]
        s.longitude = line[6]
        s.latitude = line[8]
      end
      stop.save
      p stop
    end
    p "stops finished"
  end
end
