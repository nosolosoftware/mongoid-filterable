require 'spec_helper'

describe Mongoid::Filterable do
  class City
    include Mongoid::Document
    include Mongoid::Filterable

    field :name, type: String
    field :code, type: Symbol
    field :people, type: Integer
    field :country_normalized

    filter_by(:name)
    filter_by(:code)
    filter_by(:people, lambda{|value| where(:people.gt => value)})
    filter_by_normalized(:country)
  end

  before do
    City.destroy_all
  end

  context 'when use default operator' do
    it 'should filter by default filter' do
      City.create(code: :code1)
      City.create(code: :code2)
      expect(City.filter({code: :code1}).count).to eq(1)
      expect(City.filter({code: :code1}).first.code).to eq(:code1)
    end

    it 'should filter by match filter' do
      City.create(name: 'city1')
      City.create(name: 'city2')
      expect(City.filter({name: 'city'}).count).to eq(2)
      expect(City.filter({name: 'city1'}).count).to eq(1)
      expect(City.filter({name: 'city1'}).first.name).to eq('city1')
    end

    it 'should filter by custom filter' do
      City.create(people: 100)
      City.create(people: 1000)
      expect(City.filter({people: 500}).count).to eq(1)
      expect(City.filter({people: 500}).first.people).to eq(1000)
    end

    it 'should filter by normalized filter' do
      City.create(country_normalized: 'spain')
      City.create(country_normalized: 'france')
      expect(City.filter({country: 'spain'}).count).to eq(1)
      expect(City.filter({country: 'spain'}).first.country_normalized).to eq('spain')
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
      expect(City.filter({invalid: 'val'}).count).to eq(2)
    end
  end

  context 'when filter params are nil' do
    it 'should ignore filter' do
      City.create(name: 'city1')
      City.create(name: 'city2')
      expect(City.filter(nil).count).to eq(2)
    end
  end
end
