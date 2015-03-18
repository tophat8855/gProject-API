require 'rails_helper'

describe Leg do
  describe 'legs are CRUDded in database' do
    it 'creates and saves a leg' do
      leg = Leg.new(
        :mode => 'walk',
        :start_location => '44 Tehama, San Francisco, CA',
        :end_location => '543 Howard, San Francisco, CA',
        :distance => 0.2,
        :emissions => 0.6209,
      )
      leg.save
      total = Leg.all.count

      expect(total).to eq(1)
    end

    it 'deletes a leg' do
      leg = Leg.new(
        :mode => 'walk',
        :start_location => '44 Tehama, San Francisco, CA',
        :end_location => '543 Howard, San Francisco, CA',
        :distance => 0.2,
        :emissions => 0.6209,
      )
      leg.save
      leg.delete
      total = Leg.all.count

      expect(total).to eq(0)
    end

    it 'edits a leg' do
      leg = Leg.new(
        :mode => 'walk',
        :start_location => '44 Tehama, San Francisco, CA',
        :end_location => '543 Howard, San Francisco, CA',
        :distance => 0.2,
        :emissions => 0.6209,
      )
      leg.save
      leg.mode = 'bike'
      leg.start_location = '1200 Park Ave, Emeryville, CA'
      leg.end_location = '2101 Webster Street, Oakland, CA'
      leg.distance = 2.1
      leg.emissions = 1.8627
      leg.save

      expect(leg.mode).to eq('bike')
      expect(leg.start_location).to eq('1200 Park Ave, Emeryville, CA')
      expect(leg.end_location).to eq('2101 Webster Street, Oakland, CA')
      expect(leg.distance).to eq(2.1)
      expect(leg.emissions).to eq(1.8627)
    end

    it 'deletes a leg' do
      leg = Leg.new(
        :mode => 'walk',
        :start_location => '44 Tehama, San Francisco, CA',
        :end_location => '543 Howard, San Francisco, CA',
        :distance => 0.2,
        :emissions => 0.6209,
      )
      leg.save
      expect(Leg.all.count).to eq(1)

      leg.delete
      expect(Leg.all.count).to eq(0)
    end
  end

  describe 'validations are in place for leg' do
    it 'does not save a blank leg' do
      leg = Leg.create
      expect(Leg.all.count).to eq(0)
    end

    it 'validates mode' do
      leg = Leg.create(
      :start_location => '44 Tehama, San Francisco, CA',
      :end_location => '543 Howard, San Francisco, CA',
      :distance => 0.2,
      :emissions => 0.6209,
      )
      expect(Leg.all.count).to eq(0)
    end

    it 'validates start location' do
      leg = Leg.create(
      :mode => 'walk',
      :end_location => '543 Howard, San Francisco, CA',
      :distance => 0.2,
      :emissions => 0.6209,
      )
      expect(Leg.all.count).to eq(0)
    end

    it 'validates end location' do
      leg = Leg.create(
      :mode => 'walk',
      :start_location => '44 Tehama, San Francisco, CA',
      :distance => 0.2,
      :emissions => 0.6209,
      )
      expect(Leg.all.count).to eq(0)
    end

    it 'validates distance' do
      leg = Leg.create(
      :mode => 'walk',
      :start_location => '44 Tehama, San Francisco, CA',
      :end_location => '543 Howard, San Francisco, CA',
      :emissions => 0.6209,
      )
      expect(Leg.all.count).to eq(0)
    end

    it 'validates emissions' do
      leg = Leg.create(
      :mode => 'walk',
      :start_location => '44 Tehama, San Francisco, CA',
      :end_location => '543 Howard, San Francisco, CA',
      :distance => 0.2,
      )
      expect(Leg.all.count).to eq(0)
    end
  end
end
