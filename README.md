# DaMoney
DaMoney is a gem for dealing with Money in different currencies. With DaMoney you can convert money
into different currencies, perform calculations between money amounts of the same or different
currency and compare money amounts of the same or different currency.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'da_money', git: 'git@github.com:sgrosse/da_money.git'
```

And then execute:
``` bash
$ bundle
```

## Configuration
Place a YAML file with your desired currencies and conversion rates at `config/conversion_rates.yml` e.g.
```yml
---
USD:
  EUR: 0.890295
  XBT: 0.000438134
EUR:
  USD: 1.12422
  XBT: 0.000500814
XBT:
  EUR: 2282.41
  USD: 2565.9
...

```

## Usage
Creating a new DaMoney::Money object:
``` ruby
fifty_eur = DaMoney::Money.new(50, 'EUR')
 => 50.00 EUR 

twenty_dollars = DaMoney::Money.new(20, 'USD')
 => 20.00 USD
```

Get amount and currency of a DaMoney::Money object:
``` ruby
fifty_eur.amount
 => 50.0 

fifty_eur.currency
 => "EUR"

fifty_eur.inspect
 => "50.00 EUR" 
```

Converting into different currencies:
``` ruby
DaMoney::Money.new(20, 'USD').convert_to('EUR')
 => 17.81 EUR 
```

Add or substract DaMoney::Money with other DaMoney::Money objects:
``` ruby
fifty_eur + twenty_dollars
 => 67.81 EUR

fifty_eur - twenty_dollars
 => 32.19 EUR
```

Divide or multiply DaMoney::Money by Numeric.
``` ruby
fifty_eur / 2
 => 25.00 EUR 

twenty_dollars * 3
 => 60.00 USD 
```

Comparison of DaMoney::Money objects:
``` ruby
twenty_dollars == DaMoney::Money.new(20, 'USD')
 => true 

twenty_dollars == DaMoney::Money.new(30, 'USD')
 => false

fifty_eur_in_usd = fifty_eur.convert_to('USD')
 => 56.21 USD 

fifty_eur_in_usd == fifty_eur
 => true

twenty_dollars > DaMoney::Money.new(5, 'USD')
 => true

twenty_dollars < fifty_eur
 => true 
```


## Testing
For testing via rspec execute:
``` bash
$ rspec
```

## Todo
Possible todos for further development:
* Add more test cases
* Using real time currencies from a provider like currencylayer.com

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
