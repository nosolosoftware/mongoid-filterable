# Mongoid::Filterable
![Build Status](https://travis-ci.org/nosolosoftware/mongoid-filterable.svg?branch=master)

Let you add scopes to mongoid document for filters.

## Installation

Add this line to your application's Gemfile:

    gem 'mongoid-filterable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid-filterable

## Compatibility

Mongoid Filterable supports Mongoid versions 3, 4, 5, 6 and now 7.

## Usage

#### Model

```ruby
class City
  include Mongoid::Document
  include Mongoid::Filterable

  field :name
  field :people

  filter_by(:name)
  filter_by(:people, ->(value) { where(:people.gt => value) })
  filter_by(:people_range, (lambda do |range_start, range_end|
    where(:people.lte => range_end,
          :people.gte => range_start)
  end))
end

City.create(name: 'city1', people: 100)
City.create(name: 'city2', people: 1000)
City.filtrate({name: 'city'}).count # => 2
City.filtrate({name: 'city1'}).count # => 1
City.filtrate({name: ''}).count # => 0
City.filtrate({people: 500}) # => 1
```

#### Operator

You can specify selector operator:

* $and (default operator)
* $or

```ruby
City.filtrate({name: 'city1', people: 1000}, '$and').count # => 0
City.filtrate({name: 'city1', people: 1000}, '$or').count # => 1
```

#### Range

Searches with more than one param is also available:

```ruby
City.filtrate(people_range: [500, 1000]).count # => 1
```

#### Rails controller

```ruby
class CitiesController
  def index
    respond_with City.filtrate(filter_params)
  end

  private

  def filter_params
    params.slice(:name, :people)
  end
end
```

#### With [mongoid-normalize-string](https://github.com/nosolosoftware/mongoid-normalize-strings) gem

```ruby
class City
  include Mongoid::Document
  include Mongoid::Filterable
  include Mongoid::NormalizeStrings

  field :name
  normalize :name

  filter_by_normalized(:name)
end

City.create(name: 'Cíty1')
City.create(name: 'Cíty2')
City.filtrate({name: 'city1'}).count # => 1
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/mongoid-filterable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
