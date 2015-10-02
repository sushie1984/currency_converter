require 'test_helper'

class MoneyTest < Minitest::Test
  def test_sanitize_amount_with_number
    assert_equal Money::InputSanitizer.sanitize_amount(5), '5.00'
  end

  def test_sanitize_amount_with_negative_number
    assert_equal Money::InputSanitizer.sanitize_amount(-5), '5.00'
  end

  def test_sanitize_amount_with_double_number
    assert_equal Money::InputSanitizer.sanitize_amount(5.32), '5.32'
  end

  def test_sanitize_amount_with_negative_double_number
    assert_equal Money::InputSanitizer.sanitize_amount(-5.32), '5.32'
  end

  def test_sanitize_amount_with_NAN
    assert_raises (RuntimeError) {Money::InputSanitizer.sanitize_amount('foo')}
  end

  def test_sanitize_currency_with_eur_value
    assert_equal 'EUR', Money::InputSanitizer.sanitize_currency("EUR")
  end

  def test_sanitize_currency_with_numeric
    assert_raises (RuntimeError) {Money::InputSanitizer.sanitize_currency(2.21)}
  end

  def test_sanitize_currency_with_allowed_cross_rates
    assert_equal 'EUR', Money::InputSanitizer.sanitize_currency('EUR',['EUR','USD','Bitcoin'])
  end

  def test_sanitize_currency_with_not_allowed_cross_rates
    assert_raises (RuntimeError){ Money::InputSanitizer.sanitize_currency('YEN',['EUR','USD','Bitcoin'])}
  end

  def test_sanitize_cross_rate
    rtn_cr_hash = Money::InputSanitizer.sanitize_cross_rate({'USD' => 1.23,'Bitcoin' => 0.42})
    exp_cr_hash = {'USD' => 1.23,'Bitcoin' => 0.42}
    assert_equal exp_cr_hash, rtn_cr_hash
  end

  def test_sanitize_cross_rate_with_non_hash_value
    assert_raises (RuntimeError){ Money::InputSanitizer.sanitize_cross_rate(['USD', 1.23,'Bitcoin' , 0.42])}
  end

  def test_sanitize_money_live_converter
    mlc = Money::InputSanitizer.sanitize_money_live_converter(Money::LiveConverter.new(1,'EUR'))
    assert_equal "1.00", mlc.amount
  end

  def test_sanitize_money_live_converter_with_wrong_class
    assert_raises (RuntimeError){Money::InputSanitizer.sanitize_money_live_converter(5)}
  end

end