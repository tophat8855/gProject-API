class StationsController < ApplicationController
  def bart
    @trackmiles = CSV.read('app/assets/trackdistance.csv')
    @bartemissions = CSV.read('app/assets/bartemissions.csv')

    @starting_station = params["start"]
    @ending_station = params["end"]

    start_index = @trackmiles[0].index(@starting_station)
    end_index = @trackmiles[0].index(@ending_station)

    @distance = @trackmiles[start_index][end_index]
    @emissions = @bartemissions[start_index][end_index]

    @results = Hash.new()

    nested_array = []

    result = Hash.new()
    result["start"] = @starting_station
    result["end"] = @ending_station
    result["distance"] = @distance
    result["emissions"] = @emissions

    nested_array.push(result)

    @results["stations"] = nested_array

    render json: @results
  end
end
