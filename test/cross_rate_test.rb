require 'test_helper'

class CrossRateTest < Minitest::Test
  
  def test_cross_rate_initial_static_values
    Money::CrossRate.conversion_rates
    is_euro = Money::CrossRate.currency == "EUR"
    is_hash = Money::CrossRate.cross_rate.is_a?(Hash)
    assert_equal true, is_euro && is_hash
  end
  
  def test_cross_rate_with_custom_static_values
    Money::CrossRate.conversion_rates('USD',{'EUR' => 0.9, 'Bitcoin' => 0.02})
    is_dollar = Money::CrossRate.currency == "USD"
    is_hash = Money::CrossRate.cross_rate.is_a?(Hash)
    assert_equal true, is_hash && is_dollar
  end
  
  def test_cross_rate_with_get_all_available_currencies
    Money::CrossRate.conversion_rates
    assert_equal Money::CrossRate.get_all_available_currencies, ['EUR','USD','Bitcoin']
  end
  
  def test_cross_rate_with_custom_get_all_available_currencies
    Money::CrossRate.conversion_rates('USD',{'EUR' => 0.9, 'Bitcoin' => 0.02})
    assert_equal Money::CrossRate.get_all_available_currencies, ['USD','EUR','Bitcoin']
  end
  
  def test_cross_rate_with_get_cross_value_for_currency_eur_to_usd
    Money::CrossRate.conversion_rates
    cross_value = Money::CrossRate.get_cross_value_for_currency('EUR','USD')
    assert_equal cross_value, 1.11
  end
  
  def test_cross_rate_with_get_cross_value_for_currency_usd_to_eur
    Money::CrossRate.conversion_rates
    cross_value = Money::CrossRate.get_cross_value_for_currency('USD','EUR')
    assert_equal cross_value, 0.9009009009009008
  end
  
  def test_cross_rate_with_get_cross_value_for_currency_usd_to_bitcoin
    Money::CrossRate.conversion_rates
    cross_value = Money::CrossRate.get_cross_value_for_currency('USD','Bitcoin')
    assert_equal cross_value, 236.17021276595744
  end
  
end