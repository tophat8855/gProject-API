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
end
