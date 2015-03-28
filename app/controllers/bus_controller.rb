require 'bus/bus_importer'

class BusController < ApplicationController
  def bus
    @distance = 0;

    @start = params["start"]
    @ending = params["end"]
    @route = params["route"]
    @direction = params["direction"]

    sch_routeid = BusImporter.get_sch_routeid(@route)
    sch_patternid = BusImporter.get_sch_patternid(sch_routeid, @direction)
    cpt_stoppointid = BusImporter.get_cpt_stoppoingid(sch_patternid)
    latlng_array = BusImporter.get_latlng_array(cpt_stoppointid)

    start_latlng = BusImporter.get_latlng(@start)
    end_latlng = BusImporter.get_latlng(@ending)

    start_cpt_stoppointid = BusImporter.desired_cpt_stoppointid(start_latlng, latlng_array)
    end_cpt_stoppointid = BusImporter.desired_cpt_stoppointid(end_latlng, latlng_array)

    start_seq_no = BusImporter.get_sequence_no(start_cpt_stoppointid, sch_patternid)
    end_seq_no = BusImporter.get_sequence_no(end_cpt_stoppointid, sch_patternid)

    #here is where I call the get_distance_of_leg method

    result = Hash.new()
    result["start"] = @start
    result["end"] = @ending
  end
end
