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
    response = RestClient.get "https://maps.googleapis.com/maps/api/geocode/json?address=" + address + "&key="
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
end
