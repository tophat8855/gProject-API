require 'bus/bus_importer'

namespace :bus_stops do
  desc "gets distance between bus stops"
  task get_distance: :environment do
    BusImporter.import
  end

  desc "fixes data that came in as feet to miles"
  task fix_distance: :environment do
    all_keys = BusImporter.get_sch_patternids_of_all
    all_keys.each do |route|
      distances = $redis.get(route)
      if !distances.nil?
        distances_json = JSON.parse(distances)

        new_array = distances_json.map do |leg|
          if leg.to_f > 100
            leg = (leg.to_f / 5280).round(2)
          end
          leg
        end

        $redis.set(route, new_array)
      end
    end
  end
end
