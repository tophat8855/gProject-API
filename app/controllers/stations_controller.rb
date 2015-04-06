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

    station_hash = Hash.new()
    station_hash["12TH"] = "12th St. Oakland City Center"
    station_hash["16TH"] = "16th St. Mission (SF)"
    station_hash["19TH"] = "19th St. Oakland"
    station_hash["24TH"] = "24th St. Mission (SF)"
    station_hash["ASHB"] = "Ashby (Berkeley)"
    station_hash["BALB"] = "Balboa Park (SF)"
    station_hash["BAYF"] = "Bay Fair (San Leandro)"
    station_hash["CIVC"] = "Civic Center/UN Plaza (SF)"
    station_hash["COLM"] = "Colma"
    station_hash["COLS"] = "Coliseum"
    station_hash["OAC"] = "Oakland International Airport"
    station_hash["CONC"] = "Concord"
    station_hash["CVLY"] = "Castro Valley"
    station_hash["DALY"] = "Daly City"
    station_hash["DBRK"] = "Downtown Berkeley"
    station_hash["DELN"] = "El Cerrito del Norte"
    station_hash["DUBL"] = "Dublin/Pleasanton"
    station_hash["EMBR"] = "Embarcadero (SF)"
    station_hash["FRMT"] = "Fremont"
    station_hash["FTVL"] = "Fruitvale (Oakland)"
    station_hash["GLEN"] = "Glen Park (SF)"
    station_hash["HAYW"] = "Hayward"
    station_hash["LAFY"] = "Lafayette"
    station_hash["LAKE"] = "Lake Merritt (Oakland)"
    station_hash["MACR"] = "MacArthur (Oakland)"
    station_hash["MLBR"] = "Millbrae"
    station_hash["MONT"] = "Mongomery St. (SF)"
    station_hash["NBRK"] = "North Berkeley"
    station_hash["NCON"] = "North Concord/Martinez"
    station_hash["ORIN"] = "Orinda"
    station_hash["PHIL"] = "Pleasant Hill/Contra Costa Centre"
    station_hash["PITT"] = "Pittsburg/Bay Point"
    station_hash["PLZA"] = "El Cerrito Plaza"
    station_hash["POWL"] = "Powell St. (SF)"
    station_hash["RICH"] = "Richmond"
    station_hash["ROCK"] = "Rockridge (Oakland)"
    station_hash["SANL"] = "San Leandro"
    station_hash["SBRN"] = "San Bruno"
    station_hash["SFIA"] = "San Francisco Int'l Airport"
    station_hash["SHAY"] = "South Hayward"
    station_hash["SSAN"] = "South San Francisco"
    station_hash["UCTY"] = "Union City"
    station_hash["WCRK"] = "Walnut Creek"
    station_hash["WDUB"] = "West Dublin/Pleasanton"
    station_hash["WOAK"] = "West Oakland"

    result = Hash.new()
    p @starting_station
    p station_hash[@starting_station]
    result["start"] = station_hash[@starting_station]
    result["end"] = station_hash[@ending_station]
    result["distance"] = @distance
    result["emissions"] = @emissions

    nested_array.push(result)

    @results["stations"] = nested_array

    render json: @results
  end
end
