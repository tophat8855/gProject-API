require 'tasks/bus_importer'

namespace :bus_stops do
  desc "gets distance between bus stops"
  task get_distance: :environment do

    BusImporter.distances_to_db
    #importer = BusImporter.new('bus.csv')
    #importer.import
    #patternstop_csv = CSV.read('app/assets/RTDTransitData_AC_2015.03.15/PATTERNSTOP.CSV')

    #get first stop
    #get next stop
    #query google maps direction API

    all_routes = get_sch_patternids_of_all

  end
end
