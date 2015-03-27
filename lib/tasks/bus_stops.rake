require 'bus/bus_importer'

namespace :bus_stops do
  desc "gets distance between bus stops"
  task get_distance: :environment do

    BusImporter.import
    #go through the list of routes
    #for each route, get list of stops on route
    #get each stop's latlng
    #see how long the list of stops for a route is.
    #if list length <= 10, query google API

    #if not, split into lengths of 10, query google API for those lengths
    #wait a second

    #get the response of distances between each
    #turn it into an array
    #$redis.set routename => [distance1, distance2, ...]
    #wait a second, do it again

  end
end
