require 'csv'

class BusImporter
  #def initialize(route_path, pattern_path, pattern_stop_path, stop_path)
    @@route_csv = CSV.read('data/ROUTE.csv')
    @@pattern_csv = CSV.read('data/PATTERN.csv')
    @@patternstop_csv = CSV.read('data/PATTERNSTOP.csv')
    @@stop_csv = CSV.read('data/STOP.csv')
  #end

  def self.import
    all_the_routes = get_sch_patternids_of_all
    do_these = []

    all_the_routes.each do |route|
      distances = $redis.get(route)
      if distances.nil?
        do_these << route
      end
    end
    p do_these

    all_routes = do_these
    all_stops = all_routes.map do |route|
      get_latlng_array(get_cpt_stoppointid(route))
    end

    all_stops.each do |route|
      index = all_stops.index(route)
      cpt = all_routes[index]
      p cpt
      get_it = $redis.get(cpt)
      if get_it.nil?
        begin
        distance_array = []
        route.each_cons(2) do |stop|
          start = stop[0]*","
          ending = stop[1]*","

          response = RestClient.get "https://maps.googleapis.com/maps/api/distancematrix/json?origins=" + start + "&destinations=" + ending +"&units=imperial&key=" #+ ENV['API_KEY']
          json_result = JSON.parse(response.body)
          results = json_result["rows"][0]["elements"][0]["distance"]["text"].gsub(/[^0-9.]/i, '').to_f

          if results > 200
            results = (results / 5280).round(2)
          end

          distance_array << results
          sleep 0.1
        end
        p distance_array
        p $redis.set(cpt, distance_array)

        puts "*" * 80
        rescue
          puts "Failed to return"
          next
        end
      end
    end
  end

  def self.get_sch_routeid(route)
    sch_routeid = 0
    @route_csv.each do |row|
      if row[10] == route
        sch_routeid = row[0]
      end
    end
    sch_routeid
  end

  def self.get_sch_patternid(sch_routeid, direction)
    sch_patternid = 0
    @@pattern_csv.each do |row|
      if (row[6] == sch_routeid) && (row[9].strip == direction)
        sch_patternid = row[0]
      end
    end
    sch_patternid
  end

  def self.get_cpt_stoppointid(sch_patternid)
    cpt_stoppointid = []
    @@patternstop_csv.each do |row|
      if row[5] == sch_patternid
        cpt_stoppointid << [row[1].to_i, row[7]]
      end
    end
    cpt_stoppointid.sort!

    sorted_stoppoints = cpt_stoppointid.map do |row|
      row[1]
    end
    sorted_stoppoints
  end

  def self.get_latlng(address)
    address = address.gsub!(' ', "+")
    response = RestClient.get "https://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&key=" + ENV['API_KEY']
    results = JSON.parse(response.body)
    latlng = results["results"][0]["geometry"]["location"]
    lat = latlng["lat"]
    lng = latlng["lng"]

    address_latlng = [lat, lng]
  end

  def self.distance(point1, point2)
    x2 = point2[0]
    x1 = point1[0]
    y2 = point2[1]
    y1 = point1[1]

    distance = Math.sqrt( (x2 - x1)**2 + (y2 - y1)**2 )
  end

  def self.get_latlng_array(cpt_stoppointid)
    latlng_array = []

    @@stop_csv.each do |row|
      if cpt_stoppointid.include? row[0]
        latlng_array << [row[8].to_f, row[6].to_f]
      end
    end
    latlng_array
  end

  def self.desired_cpt_stoppointid(latlng_comp, latlng_array)
    desired_cpt_stoppointid = ''

    dist_array = latlng_array.map do |point|
      distance(latlng_comp, point)
    end

    closest = dist_array.min
    closest_index = dist_array.index(closest)
    desired_latlng = latlng_array[closest_index]

    @@stop_csv.each do |row|
      float_lat = row[8].to_f
      float_lng = row[6].to_f

      if desired_latlng[0] == float_lat && desired_latlng[1] == float_lng
        desired_cpt_stoppointid = row[0]
      end
    end
    desired_cpt_stoppointid
  end

  def self.my_trip_latlng(start_stopid, end_stopid, patternid)
    trip_array = []

    start_sequence_no = get_sequence_no(start_stopid, patternid).to_i
    end_sequence_no = get_sequence_no(end_stopid, patternid).to_i

    @@patternstop_csv.each do |row|
      if (row[5] == patternid) && (start_sequence_no..end_sequence_no).include?(row[1].to_i)
        trip_array << [row[1].to_i, row[7]]
      end
    end

    trip_array.sort!
    cpt_list = trip_array.map { |array| array[1] }

    get_latlng_array(cpt_list)
  end

  def self.get_sequence_no(stopid, patternid)
    sequence_no = 0

    @@patternstop_csv.each do |row|
      if row[5] == patternid && row[7] == stopid
        sequence_no = row[1]
      end
    end

    sequence_no
  end

  def self.get_sch_patternids_of_all
    all_routes = []

    @@patternstop_csv.each do |row|
      if !all_routes.include? row[5]
        all_routes << row[5]
      end
    end

    all_routes
  end

  def self.get_distance_of_leg(start_seq_no, end_seq_no, pattern_id)
    distance_array = $redis.get(pattern_id)
    array = distance_array.gsub!(/[^0-9.,]/i, '').split(",").map!(&:to_f)

    start_index = start_seq_no.to_i - 1
    end_index = end_seq_no.to_i - 2

    distance = 0
    for index in start_index..end_index do
      distance += array[index]
    end

    distance
  end
end
