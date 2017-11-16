require 'spec_helper'

describe Mongoid::Filterable do
  class City
    include Mongoid::Document
    include Mongoid::Filterable

    default_scope -> { where(active: true) }

    field :active, type: Boolean, default: true
    field :name, type: String
    field :code, type: Symbol
    field :people, type: Integer
    field :country_normalized

    filter_by(:name)
    filter_by(:code)
    filter_by(:people, ->(value) { where(:people.gt => value) })
    filter_by(:people_in, ->(value) { where(:people.in => value) })
    filter_by(:people_range, (lambda do |range_start, range_end|
      where(:people.lte => range_end,
            :people.gte => range_start)
    end))
    filter_by_normalized(:country)
  end

  before do
    City.destroy_all
  end

  context 'when use default operator' do
    it 'should create correct selector' do
      expect(City.filter(code: :code1).selector).to eq(
        {"active" => true, "$and" => [{"code" => :code1}]}
      )
    end

    it 'should filter by default filter' do
      City.create(code: :code1)
      City.create(code: :code2)
      expect(City.filter(code: :code1).count).to eq(1)
      expect(City.filter(code: :code1).first.code).to eq(:code1)
    end

    it 'should filter by match filter' do
      City.create(name: 'city1')
      City.create(name: 'city2')
      expect(City.filter(name: 'city').count).to eq(2)
      expect(City.filter(name: 'city1').count).to eq(1)
      expect(City.filter(name: 'city1').first.name).to eq('city1')
    end

    it 'should filter by custom filter' do
      City.create(people: 100)
      City.create(people: 1000)
      expect(City.filter(people: 500).count).to eq(1)
      expect(City.filter(people: 500).first.people).to eq(1000)
    end

    it 'should filter by normalized filter' do
      City.create(country_normalized: 'spain')
      City.create(country_normalized: 'france')
      expect(City.filter(country: 'spain').count).to eq(1)
      expect(City.filter(country: 'spain').first.country_normalized).to eq('spain')
    end

    it 'should respect previous selector' do
      City.create(name: 'city1', people: 100)
      City.create(name: 'city2', people: 1000)
      City.create(name: 'city3', people: 2000)
      expect(City.where(name: 'city2').filter(people: '500').count).to eq(1)
      expect(City.where(name: 'city2').filter(people: '500').first.name).to eq('city2')
    end
  end

  context 'when use $and operator' do
    it 'should filter using and query' do
      City.create(name: 'city1', people: 100)
      City.create(name: 'city2', people: 2000)
      expect(City.filter({name: 'city1', people: '2000'}, '$and').count).to eq(0)
    end
  end

  context 'when use $or operator' do
    it 'should filter using or query' do
      City.create(name: 'city1', people: 100)
      City.create(name: 'city2', people: 2000)
      expect(City.filter({name: 'city1', people: '2000'}, '$or').count).to eq(1)
    end
  end

  context 'when use invalid filter' do
    it 'should ignore filter' do
      City.create(name: 'city1')
      City.create(name: 'city2')
      expect(City.filter(invalid: 'val').count).to eq(2)
    end
  end

  context 'when filter params are nil' do
    it 'should ignore filter' do
      City.create(name: 'city1')
      City.create(name: 'city2')
      expect(City.filter(nil).count).to eq(2)
    end
  end

  context 'when value is an array' do
    it 'filter should receive all the values' do
      City.create(people: 100)
      City.create(people: 500)
      City.create(people: 1000)
      City.create(people: 1000)
      expect(City.filter(people_range: [500, 1000]).count).to eq(3)
    end

    it 'does not break compatibility with filters receiving only one param as array' do
      City.create(people: 100)
      City.create(people: 500)
      City.create(people: 1000)
      City.create(people: 1000)
      expect(City.filter(people_in: [500, 100]).count).to eq(2)
    end
  end
end
