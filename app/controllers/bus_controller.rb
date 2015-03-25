class BusController < ApplicationController
  include BusHelper
  def bus
    @distance = 0;

    @start = "40th St. San Pablo Ave Emeryville, CA"
    @end = "University Ave San Pablo Ave Berkeley, CA"
    @route = "72"
    @direction = "N"

    sch_routeid = get_sch_routeid(@route)
    sch_patternid = get_sch_patternid(sch_routeid, @direction)
    list_of_bus_stop_ids_on_route = get_cpt_stoppointid(sch_patternid)

    latlngs_of_bus_stops_on_route = get_latlng_array(list_of_bus_stop_ids_on_route)
    latlng_of_start = get_latlng(@start)
    latlng_of_end = get_latlng(@end)

    stop_id_of_start = desired_cpt_stoppointid(latlng_of_start, latlngs_of_bus_stops_on_route)
    stop_id_of_end = desired_cpt_stoppointid(latlng_of_end, latlngs_of_bus_stops_on_route)

    array_of_my_trip = my_trip_latlng(stop_id_of_start, stop_id_of_end, sch_patternid)

    array_of_my_trip.each_slice()
    puts array_of_my_trip


  end
end
