require 'csv/csv_importer'

namespace :csv do
  desc "puts csv tables into database"
  task import_csv: :environment do

    importer = CsvImporter.new('data/ROUTE.csv', 'data/PATTERN.csv', 'data/PATTERNSTOP.csv',
       'data/STOP.csv')

    importer.import
  end
end
