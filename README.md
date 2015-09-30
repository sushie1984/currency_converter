# Money::LiveConverter

The Money::LiveConverter is a demo gem with focus/exercise on the built-in minitest and comments of methods within ruby code.

## Installation

(1) git clone https://github.com/sushie1984/currency_converter.git
(2) gem build money.gemspec
(3) gem install ./money-MAJOR.MINOR.BUILD.gem

## Usage
Init irb with the new gem money:
(1) irb
(2) require "money"

Add/(re)set Conversion Rates (This can be done at any time to update the conversion rates):
 base_currency = 'EUR'
 cross_rate = {'USD' => 1.12, 'Bitcoin' => 0.0047}
 Money::LiveConverter.conversion_rates(base_currency,cross_rate)

Create Instance:
 euro = Money::LiveConverter.new(5.0,'EUR')

Convert Instance and get a new Instance out of it:
 dollar = euro.convert_to('USD')

Arithmetic Operations (The first Instance is the base currency that is used for the conversion of the second instance):
 euro + dollar
 euro - dollar
 3*euro
 euro/2
 dollar > euro
 euro < dollar
 dollar == euro
 
## Development

For Arithmetic Operations check out method arithmetic_op in money.rb

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sushie1984/currency_converter.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

