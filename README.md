# Mongoid::Filterable

Let you add scopes to mongoid document for filters.

## Installation

Add this line to your application's Gemfile:

    gem 'mongoid-filterable'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mongoid-filterable

## Usage

#### Model

```ruby
class City
  include Mongoid::Document
  include Mongoid::Filterable

  field :name
  field :people

  filter_by(:name)
  filter_by(:people, lambda{|value| where(:people.gt => value)})
end

City.create(name: 'city1', people: 100)
City.create(name: 'city2', people: 1000)
City.filter({name: 'city1'}).count # => 1
City.filter({people: 500}) # => 1
```

#### Rails controller

```ruby
class CitiesController
  def index
    respond_with City.filter(filter_params)
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

  filter_by_normalize(:name)
end

City.create(name: 'Cíty1')
City.create(name: 'Cíty2')
City.filter({name: 'city1'}).count # => 1
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/mongoid-filterable/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
