require 'rails_helper'

RSpec.describe BusHelper, :type => :helper do
  describe 'can get desired values from csvs' do
    it 'gets a SCH_ROUTEID from the ROUTE.CSV when the route is a string' do
      route = "72R"
      sch_routeid = get_sch_routeid(route)

      expect(sch_routeid).to eq('43770')
    end

    it 'gets a SCH_ROUTEID from the ROUTE.CSV when the route is a number' do
      route = "72"
      sch_routeid = get_sch_routeid(route)

      expect(sch_routeid).to eq('43768')
    end

    it 'gets a SCH_PATTERNID from the PATTERN.CSV file' do
      sch_routeid = '43770'
      direction = 'N'
      sch_patternid = get_sch_patternid(sch_routeid, direction)

      expect(sch_patternid).to eq('158608')
    end
  end
end
