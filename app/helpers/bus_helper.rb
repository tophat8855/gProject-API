module BusHelper
  def get_sch_routeid(route)
    sch_routeid = 0
    route_csv = CSV.read('app/assets/RTDTransitData_AC_2015.03.15/ROUTE.CSV')
    route_csv.each do |row|
      if row[10] == route
        sch_routeid = row[0]
      end
    end
    sch_routeid
  end

  def get_sch_patternid(sch_routeid, direction)
    sch_patternid = 0
    pattern_csv = CSV.read('app/assets/RTDTransitData_AC_2015.03.15/PATTERN.CSV')
    pattern_csv.each do |row|
      if (row[6] == sch_routeid) && (row[9].strip == direction)
        sch_patternid = row[0]
      end
    end
    sch_patternid
  end

  def get_cpt_stoppointid(sch_patternid)
    cpt_stoppointid = []
    patternstop_csv = CSV.read('app/assets/RTDTransitData_AC_2015.03.15/PATTERNSTOP.CSV')
    patternstop_csv.each do |row|
      if row[5] == sch_patternid
        cpt_stoppointid << row[7]
      end
    end
    cpt_stoppointid
  end

  def get_latlng(address)
    address = address.gsub!(' ', "+")
    response = RestClient.get "https://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&key=" + ENV['API_KEY']
    results = JSON.parse(response.body)
    latlng = results["results"][0]["geometry"]["location"]
    lat = latlng["lat"]
    lng = latlng["lng"]

    address_latlng = [lat, lng]
  end

  def distance(point1, point2)
    x2 = point2[0]
    x1 = point1[0]
    y2 = point2[1]
    y1 = point1[1]

    distance = Math.sqrt( (x2 - x1)**2 + (y2 - y1)**2 )
  end

  def get_latlng_array(cpt_stoppointid)
    latlng_array = []
    stop_csv = CSV.read('app/assets/RTDTransitData_AC_2015.03.15/STOP.CSV')

    stop_csv.each do |row|
      if cpt_stoppointid.include? row[0]
        latlng_array << [row[8].to_f, row[6].to_f]
      end
    end
    latlng_array
  end

  def desired_cpt_stoppointid(latlng_comp, latlng_array)
    desired_cpt_stoppointid = ''

    dist_array = latlng_array.map do |point|
      distance(latlng_comp, point)
    end

    closest = dist_array.min
    closest_index = dist_array.index(closest)
    desired_latlng = latlng_array[closest_index]

    stop_csv = CSV.read('app/assets/RTDTransitData_AC_2015.03.15/STOP.CSV')
    stop_csv.each do |row|
      float_lat = row[8].to_f
      float_lng = row[6].to_f

      if desired_latlng[0] == float_lat && desired_latlng[1] == float_lng
        desired_cpt_stoppointid = row[0]
      end
    end
    desired_cpt_stoppointid
  end

  def my_trip_latlng(start_stopid, end_stopid, patternid)

    trip_array = []

    patternstop_csv = CSV.read('app/assets/RTDTransitData_AC_2015.03.15/PATTERNSTOP.CSV')

    start_sequence_no = get_sequence_no(start_stopid, patternid).to_i
    end_sequence_no = get_sequence_no(end_stopid, patternid).to_i

    patternstop_csv.each do |row|
      if (row[5] == patternid) && (start_sequence_no..end_sequence_no).include?(row[1].to_i)
        trip_array << [row[1].to_i, row[7]]
      end
    end

    trip_array.sort!
    cpt_list = trip_array.map { |array| array[1] }

    get_latlng_array(cpt_list)
  end

  def get_sequence_no(stopid, patternid)
    patternstop_csv = CSV.read('app/assets/RTDTransitData_AC_2015.03.15/PATTERNSTOP.CSV')
    sequence_no = 0

    patternstop_csv.each do |row|
      if row[5] == patternid && row[7] == stopid
        sequence_no = row[1]
      end
    end

    sequence_no
  end

  def get_sch_patternids_of_all
    all_routes = []
    patternstop_csv = CSV.read('app/assets/RTDTransitData_AC_2015.03.15/PATTERNSTOP.CSV')

    patternstop_csv.each do |row|
      if !all_routes.include? row[5]
        all_routes << row[5]
      end
    end

    all_routes
  end
end
