require 'rails_helper'
require 'bus/bus_importer'

RSpec.describe BusImporter do
  describe 'can get desired values from csvs' do
    it 'gets a SCH_ROUTEID from the ROUTE.CSV when the route is a string' do
      route = "72R"
      sch_routeid = BusImporter.get_sch_routeid(route)

      expect(sch_routeid).to eq('43770')
    end

    it 'gets a SCH_ROUTEID from the ROUTE.CSV when the route is a number' do
      route = "72"
      sch_routeid = BusImporter.get_sch_routeid(route)

      expect(sch_routeid).to eq('43768')
    end

    it 'gets a SCH_PATTERNID from the PATTERN.CSV file' do
      sch_routeid = '43770'
      direction = 'N'
      sch_patternid = BusImporter.get_sch_patternid(sch_routeid, direction)

      expect(sch_patternid).to eq('158608')
    end

    it 'gets a list of CPT_STOPPOINTID from the PATTERN_STOP.CSV' do
      sch_patternid = '158608'
      cpt_stoppointid = BusImporter.get_cpt_stoppointid(sch_patternid)

      expect(cpt_stoppointid.length).to eq(27)
      expect(cpt_stoppointid).to eq(['12016322','12013481', '12013490', '12013457', '1553117',
        '1553165', '12017093', '12016971', '12016978', '12017082', '12016993',
        '12016997', '12017025', '12017087', '12017034', '12017080', '12017007',
        '12017059', '12017071', '1533533', '12017049', '12017031', '12017078',
        '12017090', '12017092', '12017027', '1534322'])
    end

    it 'gives the lat/lng for an address' do
      start_address = "40th St. San Pablo Ave Emeryville, CA"
      latlng = BusImporter.get_latlng(start_address)

      expect(latlng).to eq([37.831195, -122.279198])
    end

    it 'gets the distance between two points' do
      first_point = [0, 0]
      second_point = [3, 4]

      distance = BusImporter.distance(first_point, second_point)

      expect(distance).to eq(5)
    end

    it 'gets the distance between two latlngs' do
      first_latlng = [37.831195, -122.279198]
      second_latlng = [37.8130485, -122.2739678]

      distance = BusImporter.distance(first_latlng, second_latlng)

      expect(distance).to eq(0.01888519140199558)
    end

    it 'returns a list of latlng from the STOPS.csv' do
      cpt_stoppointid = ['12016322','12013481', '12013490', '12013457', '1553117',
        '1553165', '12017093', '12016971', '12016978', '12017082', '12016993',
        '12016997', '12017025', '12017087', '12017034', '12017080', '12017007',
        '12017059', '12017071', '1533533', '12017049', '12017031', '12017078',
        '12017090', '12017092', '12017027', '1534322']

      latlng_array = BusImporter.get_latlng_array(cpt_stoppointid)

      expect(latlng_array.length).to eq(27)
      expect(latlng_array).to eq([[37.92488940, -122.31683060],
        [37.97107940, -122.33987530], [37.804542, -122.270992],
        [37.809432, -122.269009], [37.80280620, -122.27201520],
        [37.79658060, -122.27588410], [37.79969010, -122.273941],
        [37.79665690, -122.27807950], [37.82124660, -122.27658260],
        [37.83148680, -122.27988350], [37.84721260, -122.28495710],
        [37.85251410, -122.28667450], [37.89934740, -122.30186560],
        [37.86146620, -122.28954640], [37.966699, -122.34428250],
        [37.944037, -122.329083], [37.88082890, -122.29578260],
        [37.932723, -122.32351410], [37.91186360, -122.30882390],
        [37.92120170, -122.31533010], [37.95246510, -122.333118],
        [37.89006550, -122.29874730], [37.84142570, -122.28308210],
        [37.869467, -122.29211810], [37.955914, -122.33606190],
        [37.96079340, -122.34286730], [37.81304850, -122.27396780]])
    end

    it 'finds the CPT_STOPPOINTID of the stop that is closest to a certain lat lng' do
      latlng_to_compare = [37.831195, -122.279198]

      latlng_array = [[37.92488940, -122.31683060],
        [37.97107940, -122.33987530], [37.804542, -122.270992],
        [37.809432, -122.269009], [37.80280620, -122.27201520],
        [37.79658060, -122.27588410], [37.79969010, -122.273941],
        [37.79665690, -122.27807950], [37.82124660, -122.27658260],
        [37.83148680, -122.27988350], [37.84721260, -122.28495710],
        [37.85251410, -122.28667450], [37.89934740, -122.30186560],
        [37.86146620, -122.28954640], [37.966699, -122.34428250],
        [37.944037, -122.329083], [37.88082890, -122.29578260],
        [37.932723, -122.32351410], [37.91186360, -122.30882390],
        [37.92120170, -122.31533010], [37.95246510, -122.333118],
        [37.89006550, -122.29874730], [37.84142570, -122.28308210],
        [37.869467, -122.29211810], [37.955914, -122.33606190],
        [37.96079340, -122.34286730], [37.81304850, -122.27396780]]

      cpt_stoppointid = BusImporter.desired_cpt_stoppointid(latlng_to_compare, latlng_array)

      expect(cpt_stoppointid).to eq('12016978')
    end

    it 'gives a sequence number' do
      stopid = '12016978'
      patternid = '158608'

      sequence_no = BusImporter.get_sequence_no(stopid, patternid)

      expect(sequence_no).to eq('9')
    end

    it 'takes 2 stop point ids and returns an ordered array of latlngs of bus stops in between them, inclusive' do
      starting_stoppointid = '12016978'
      ending_stoppointid = '12017087'
      patternid = '158608'

      array_of_latlng_of_trip = BusImporter.my_trip_latlng(starting_stoppointid, ending_stoppointid, patternid)

      expect(array_of_latlng_of_trip.length).to eq(6)
      expect(array_of_latlng_of_trip).to eq([[37.8314868, -122.2798835], [37.8472126, -122.2849571], [37.8525141, -122.2866745], [37.8614662, -122.2895464], [37.8414257, -122.2830821], [37.869467, -122.2921181]])
    end

    it 'gets a list of all the SCH_PATTERNIDs' do
      all_routes = BusImporter.get_sch_patternids_of_all

      expect(all_routes.length).to eq(442)
    end
  end
end
