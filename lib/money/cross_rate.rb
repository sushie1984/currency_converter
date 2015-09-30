module Money
  class CrossRate
      ############################################################################
      # HINT/Lessons learnt:
      # As to http://stackoverflow.com/questions/895747/how-can-rubys-attr-accessor-produce-class-variables-or-class-instance-variables
      # this is similar to rails cattr_accessor
      ############################################################################
      class << self
        attr_accessor :currency
        attr_accessor :cross_rate
        ############################################################################
        # Setting the conversion rates
        # according to a base currency.
        # params:
        # +currency+:: Is a String defining the base currency
        # +cross_rate+:: Is a Hash containing all available rates
        #                in correlation with the currency.
        ############################################################################
        def conversion_rates(currency="EUR",cross_rate={'USD' => 1.11, 'Bitcoin' => 0.0047})
          @currency = Money::InputSanitizer.sanitize_currency(currency)
          @cross_rate = Money::InputSanitizer.sanitize_cross_rate(cross_rate)
        end
        ############################################################################
        # Returns an aray containing all possible currencies.
        # returns:
        # +[Array]+: An array containg all available currencies.
        ############################################################################
        def get_all_available_currencies
          [@currency].concat @cross_rate.keys
        end
        
        ############################################################################
        # Methods calculates a cross-value for two currencies. The first
        # currencies therefore defines what cross-rate is the base one, wheras
        # the second one defines in what currency it should be converted. 
        # If the first one is not the one defined in @currency then depending
        # on the second one a calculation of the corresponding cross-value is done.
        # params:
        # +base_currency+:: The base currency that is used for further converting ops.
        # +exchange_currency+:: The currency that base_currency is going to be converted.
        # returns:
        # A Numeric Object containing the cross-value.
        ############################################################################
        def get_cross_value_for_currency(base_currency,exchange_currency)
          return @cross_rate[exchange_currency] if base_currency == @currency
          return (1.00/@cross_rate[base_currency] ) if (exchange_currency == @currency)
          b_curr_to_exch_curr = get_cross_value_for_currency(@currency,base_currency)
          exch_curr_to_b_curr = get_cross_value_for_currency(exchange_currency,@currency)
          return b_curr_to_exch_curr*exch_curr_to_b_curr     
        end  
        
      end    
  end
end