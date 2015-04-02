require 'bus/bus_importer'

class BusController < ApplicationController
  def bus
    @distance = 0;

    @start = params["start"]
    @ending = params["end"]
    @route = params["route"]
    @direction = params["direction"]


    sch_routeid = BusImporter.get_sch_routeid(@route)
    puts "Sch Route id = "
    puts sch_routeid
    sch_patternid = BusImporter.get_sch_patternid(sch_routeid, @direction)
    puts "Sch Pattern id = "
    puts sch_patternid
    cpt_stoppointid = BusImporter.get_cpt_stoppointid(sch_patternid)
    puts "cpt_stoppointid ="
    puts cpt_stoppointid
    latlng_array = BusImporter.get_latlng_array(cpt_stoppointid)
    puts "latlng_array = "
    puts latlng_array
    start_latlng = BusImporter.get_latlng(@start)
    puts "start_latlng"
    puts start_latlng
    end_latlng = BusImporter.get_latlng(@ending)
    puts "end latlng"
    puts end_latlng
    start_cpt_stoppointid = BusImporter.desired_cpt_stoppointid(start_latlng, latlng_array)
    puts "start_spt_stoppointid"
    puts start_cpt_stoppointid
    end_cpt_stoppointid = BusImporter.desired_cpt_stoppointid(end_latlng, latlng_array)
    puts "end_cpt_stoppointid"
    puts end_cpt_stoppointid
    start_seq_no = BusImporter.get_sequence_no(start_cpt_stoppointid, sch_patternid)
    puts "sequenc numbers:"
    puts start_seq_no
    end_seq_no = BusImporter.get_sequence_no(end_cpt_stoppointid, sch_patternid)
    puts end_seq_no
    @distance = BusImporter.get_distance_of_leg(start_seq_no, end_seq_no, sch_patternid).round(2)
    @emissions = (0.15873264 * @distance).round(2)   #emissions data from http://www.buses.org/files/ComparativeEnergy.pdf
    puts "distance"
    puts @distance
    puts "emissions"
    puts @emissions
    @results = Hash.new()

    nested_array = []

    result = Hash.new()
    result["start"] = @start
    result["end"] = @ending
    result["route"] = @route
    result["direction"] = @direction
    result["distance"] = @distance
    result["emissions"] = @emissions

    nested_array.push(result)

    @results["bus"] = nested_array

    render json: @results
  end
end
