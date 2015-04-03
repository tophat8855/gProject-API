#require 'bus/bus_importer'

class BusController < ApplicationController
  def bus
    @distance = 0;

    @start = params["start"]
    @ending = params["end"]
    @route = params["route"]
    @direction = params["direction"]

    route_id = get_route_id(@route)
    pattern_id = get_pattern_id(route_id, @direction)
    stop_id = get_stop_id(pattern_id)
    latlng_array = get_latlng_array(stop_id)
    start_latlng = get_latlng(@start)
    end_latlng = get_latlng(@ending)
    start_cpt_stoppointid = desired_stop(start_latlng, latlng_array)
    end_cpt_stoppointid = desired_stop(end_latlng, latlng_array)
    start_seq_no = get_sequence_no(start_cpt_stoppointid, pattern_id)
    end_seq_no = get_sequence_no(end_cpt_stoppointid, pattern_id)

    @distance = get_distance_of_leg(start_seq_no, end_seq_no, pattern_id).round(2)
    @emissions = (0.15873264 * @distance).round(2)   #emissions data from http://www.buses.org/files/ComparativeEnergy.pdf
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

  private

  def get_distance_of_leg(start_seq_no, end_seq_no, pattern_id)
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

  def get_sequence_no(stopid, patternid)
    sequence_no = PatternStop.where stop_id: stopid, pattern_id: patternid
    sequence_no[0].seq_no
  end

  def desired_stop(latlng_comp, latlng_array)
    dist_array = latlng_array.map do |point|
      distance(latlng_comp, point)
    end

    closest = dist_array.min
    closest_index = dist_array.index(closest)
    desired_latlng = latlng_array[closest_index]
    desired_lat = desired_latlng[0]
    desired_lng = desired_latlng[1]

    desired_stop = Stop.where longitude: desired_lng, latitude: desired_lat

    desired_stop[0].id
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

  def get_latlng_array(stop_id)
    latlng_array = stop_id.map do |id|
      stop = Stop.where id: id
      [stop[0].latitude, stop[0].longitude]
    end
  end

  def get_stop_id(pattern_id)
    all_stops = PatternStop.where pattern_id: pattern_id
    all_ids = all_stops.map do |stop|
      stop.stop_id
    end
  end

  def get_pattern_id(route_id, direction)
    pattern_id = Pattern.where bus_route_id: route_id, direction: direction
    pattern_id[0].id
  end

  def get_route_id(route)
    route_id = BusRoute.where name: route
    route_id[0].id
  end

  def distance(point1, point2)
    x2 = point2[0]
    x1 = point1[0]
    y2 = point2[1]
    y1 = point1[1]

    distance = Math.sqrt( (x2 - x1)**2 + (y2 - y1)**2 )
  end
end
