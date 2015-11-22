# SimpleMapper

A super simple [datamapper](http://martinfowler.com/eaaCatalog/dataMapper.html)
built on top of Sequel. For creating
[repository](http://martinfowler.com/eaaCatalog/repository.html) like objects.

## Installation

Add this line to your application's Gemfile:

    gem 'simple_mapper'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install simple_mapper

## Usage

```ruby
require 'simple_mapper'

class Account
  def initialize(attrs={})
    #some way to covert attrs to @attibutes
  end
end

class Accounts
  include SimpleMapper
  dataset :accounts
end

DB = Sequel.connect

accounts = Accounts.new(DB)

accounts.all #=> all accounts

# CRUD

account = Account.new(email: 'dave@example.com')

accounts.create(account)

accounts.find(1)

accounts.update(account)

accounts.delete(account)
```

TODO: Improve usage instructions :)

## Contributing

1. Fork it ( https://github.com/stengland/simple_mapper/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
