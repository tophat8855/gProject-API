class BusController < ApplicationController
  def bus
    @patternstop_csv = CSV.read('app/assets/RTDTransitData_AC_2015.03.15/PATTERNSTOP.CSV')
    @stop_csv = CSV.read('app/assets/RTDTransitData_AC_2015.03.15/STOP.CSV')

    @start = "40th St. San Pablo Ave Emeryville, CA"
    @end = "University Ave San Pablo Ave Berkeley, CA"
    @route = "72"
    @direction = "N"

    sch_routeid = get_sch_routeid(@route)
    sch_patternid = get_sch_patternid(sch_routeid)

    puts "PUTSING ALL THE THINGS!"
    puts sch_routeid
  end

end
