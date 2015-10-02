require 'test_helper'

class MoneyTest < Minitest::Test
  def setup
    @money = Money::LiveConverter.new
  end

  def test_that_it_has_a_version_number
    refute_nil ::Money::VERSION
  end

  def test_instance_has_default_amount
    assert_equal @money.amount, '1.00'
  end

  def test_instance_has_default_currency
    assert_equal @money.currency , 'EUR'
  end

  def test_inspect_with_instance_based_on_values
    money = Money::LiveConverter.new(5,'EUR')
    assert_equal money.inspect , '5.00 EUR'
  end

  def test_instance_with_not_allowed_currency
    money = Money::LiveConverter.new(5,'YEN')
    assert_equal money.amount.nil? && money.currency.nil?, true
  end

  def test_instance_with_custom_conversion
    Money::LiveConverter.conversion_rates('USD',{'EUR'=> 0.99,'Bitcoin' => 0.03})
    money = Money::LiveConverter.new(5,'USD')
    assert_equal money.amount, '5.00'
  end

  def test_instance_with_convert_to_dollar
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    money = Money::LiveConverter.new(5,'EUR')
    dollar_instance = money.convert_to('USD')
    assert_equal '5.55', dollar_instance.amount
  end

  def test_instance_with_convert_to_non_allowed_yen
    @money = Money::LiveConverter.new(5,'EUR')
    yen_instance = @money.convert_to('YEN')
    assert_equal nil, yen_instance
  end

  def test_instance_with_inital_dollar_to_euro
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    dollar_instance = Money::LiveConverter.new(15,'USD')
    euro_instance = dollar_instance.convert_to('EUR')
    assert_equal "13.51", euro_instance.amount
  end

  def test_instance_binary_plus_op
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    euro1 = Money::LiveConverter.new(15,'EUR')
    euro2 = Money::LiveConverter.new(15.04,'EUR')
    euro_sum = euro1 + euro2
    assert_equal "30.04", euro_sum.amount
  end

  def test_instance_binary_plus_op_on_eur_and_usd
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    euro1 = Money::LiveConverter.new(15.04,'EUR')
    dollar = Money::LiveConverter.new(1,'USD')
    euro_sum = euro1 + dollar
    assert_equal "15.94", euro_sum.amount
  end

  def test_instance_binary_minus_op
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    euro1 = Money::LiveConverter.new(16.00,'EUR')
    euro2 = Money::LiveConverter.new(15.04,'EUR')
    euro_sum = euro1 - euro2
    assert_equal "0.96", euro_sum.amount
  end

  def test_instance_binary_minus_op_on_eur_to_usd
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    euro1 = Money::LiveConverter.new(16.00,'EUR')
    dollar = Money::LiveConverter.new(1,'USD')
    euro_sum = euro1 - dollar
    assert_equal "15.10", euro_sum.amount
  end

  def test_instance_binary_multiplication
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    euro1 = Money::LiveConverter.new(5.20,'EUR')
    euro_sum = euro1 * 3
    assert_equal "15.60", euro_sum.amount
  end

  def test_instance_binary_multiplication_two
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    euro1 = Money::LiveConverter.new(2,'EUR')
    euro_sum = euro1 * 2.5
    assert_equal "5.00", euro_sum.amount
  end

  def test_instance_binary_multiplication_three
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    euro1 = Money::LiveConverter.new(2,'EUR')
    euro_sum = euro1 * 0
    assert_equal "0.00", euro_sum.amount
  end

  def test_instance_binary_division
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    euro1 = Money::LiveConverter.new(2.5,'EUR')
    euro_sum = euro1 / 2
    assert_equal "1.25", euro_sum.amount
  end

  def test_instance_binary_division_through_zero
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    euro1 = Money::LiveConverter.new(2.5,'EUR')
    euro_sum = euro1 / 0
    assert_equal nil, euro_sum
  end

  def test_instance_binary_equality_of_eur_instances
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    euro1 = Money::LiveConverter.new(2.5,'EUR')
    euro2 = Money::LiveConverter.new(2.5,'EUR')
    euro_sum = euro1 == euro2
    assert_equal true, euro_sum
  end

  def test_instance_binary_equality_of_eur_and_usd_instance
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    euro1 = Money::LiveConverter.new(0.90,'EUR')
    euro2 = Money::LiveConverter.new(1,'USD')
    euro_sum = euro1 == euro2
    assert_equal true, euro_sum
  end

  def test_instance_binary_equality_of_eur_and_usd_instance_two
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    euro1 = Money::LiveConverter.new(1,'EUR')
    dollar = Money::LiveConverter.new(1,'USD')
    euro_sum = euro1 == dollar
    assert_equal false, euro_sum
  end

  def test_instance_binary_equality_of_eur_and_usd_instance_three
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    euro1 = Money::LiveConverter.new(5.6,'EUR')
    euro1_to_usd = euro1.convert_to('USD')
    euro_sum = euro1 == euro1_to_usd
    assert_equal true, euro_sum
  end

  def test_instance_binary_less_of_eur
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    euro1 = Money::LiveConverter.new(5,'EUR')
    euro2 = Money::LiveConverter.new(6,'EUR')
    euro_sum = euro1 < euro2
    assert_equal true, euro_sum
  end

  def test_instance_binary_less_of_eur_and_dollar
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    euro1 = Money::LiveConverter.new(0.8,'EUR')
    dollar = Money::LiveConverter.new(1,'USD')
    euro_sum = euro1 < dollar
    assert_equal true, euro_sum
  end

  def test_instance_binary_less_of_eur_and_dollar_two
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    euro1 = Money::LiveConverter.new(1,'EUR')
    dollar = Money::LiveConverter.new(1,'USD')
    euro_sum = euro1 < dollar
    assert_equal false, euro_sum
  end

  def test_instance_binary_greater_of_eur
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    euro1 = Money::LiveConverter.new(5,'EUR')
    euro2 = Money::LiveConverter.new(4,'EUR')
    euro_sum = euro1 > euro2
    assert_equal true, euro_sum
  end

  def test_instance_binary_greater_of_eur_and_dollar
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    euro1 = Money::LiveConverter.new(0.91,'EUR')
    dollar = Money::LiveConverter.new(1,'USD')
    euro_sum = euro1 > dollar
    assert_equal true, euro_sum
  end

  def test_instance_binary_greater_of_eur_and_dollar_two
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    euro1 = Money::LiveConverter.new(0.89,'EUR')
    dollar = Money::LiveConverter.new(1,'USD')
    euro_sum = euro1 > dollar
    assert_equal false, euro_sum
  end

  def test_instance_binary_greater_of_eur_and_dollar_three
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    euro1 = Money::LiveConverter.new(0.91,'EUR')
    dollar = Money::LiveConverter.new(1,'USD')
    euro_sum = dollar < euro1
    assert_equal true, euro_sum
  end

  def test_instance_binary_adding_bitcoin_usd
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    dollar = Money::LiveConverter.new(1,'USD')
    bitcoin = Money::LiveConverter.new(1,'Bitcoin')
    bitcoin_sum = bitcoin + dollar
    assert_equal "237.17", bitcoin_sum.amount
  end

  def test_instance_binary_minus_bitcoin_usd
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    dollar = Money::LiveConverter.new(1,'USD')
    bitcoin = Money::LiveConverter.new(1,'Bitcoin')
    bitcoin_sum = bitcoin - dollar
    assert_equal "235.17", bitcoin_sum.amount
  end

  def test_instance_binary_equality_bitcoin_usd
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    dollar = Money::LiveConverter.new(1,'USD')
    bitcoin = Money::LiveConverter.new(1,'Bitcoin')
    bitcoin_sum = bitcoin == dollar
    assert_equal false, bitcoin_sum
  end

  def test_instance_binary_less_bitcoin_usd
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    dollar = Money::LiveConverter.new(1,'USD')
    bitcoin = Money::LiveConverter.new(1,'Bitcoin')
    bitcoin_sum = bitcoin < dollar
    assert_equal true, bitcoin_sum
  end

  def test_instance_binary_greater_bitcoin_usd
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    dollar = Money::LiveConverter.new(1,'USD')
    bitcoin = Money::LiveConverter.new(1,'Bitcoin')
    bitcoin_sum = bitcoin > dollar
    assert_equal false, bitcoin_sum
  end

  def test_fifty_euros_to_twenty_dollars
    #For clean conversion rates
    Money::CrossRate.conversion_rates
    dollar = Money::LiveConverter.new(20,'USD')
    euro = Money::LiveConverter.new(50,'EUR')
    assert_equal true, dollar < euro
  end

end
