module Money
	class InputSanitizer
		############################################################################
		# Method checks if the parameter is a numeric value and also if the numeric
		# is positiv.
		# params:
		# +amount+:: A numeric value defining the amount of Money::LiveConverter instance.
		# returns:
		# The absolute numeric value. 
		############################################################################
		def self.sanitize_amount(amount)
		  raise "Please use a positive number as first parameter. E.g. Money::LiveConverter.new(4,'EUR')" unless amount.is_a?(Numeric)
			if amount < 0
			   amount = amount*(-1)
			   puts "Your amount was a negative number. We assume you meant a positive, so we use this value instead."
			end
			'%.2f'% amount
		end
		############################################################################
    # Method checks if the parameter is a String and if defined if the parameter
    # is within a set of values.
    # is positiv.
    # params:
    # +currency+:: A String defining the currency of Money::LiveConverter instance. 
    # +allowed_cross_rates+:: An array defining a set of values which +currency+ can be be.
    # returns:
    # The String currency value. 
    ############################################################################
		def self.sanitize_currency(currency, allowed_cross_rates=[])
			raise "Argument Currency must be a String. E.g. Money::LiveConverter.new(4,'EUR')." unless currency.is_a?(String)
			unless allowed_cross_rates.empty?
			  raise "Argument Currency must be one of the following currencies: #{allowed_cross_rates}." unless allowed_cross_rates.include?(currency)
			end
			currency
		end
		############################################################################
    # Method checks if the parameter is a Hash value.
    # params:
    # +cross_rate+:: A Hash defining all available cross values for a given currency.
    # returns:
    # A Hash defining all available cross values 
    ############################################################################
		def self.sanitize_cross_rate(cross_rate)
		  raise "Please use a Hash in the form of {'USD' => 1.11,'Bitcoin' => 0.0046}." unless cross_rate.is_a?(Hash)
		  cross_rate
		end	

    ############################################################################
    # Method checks if the parameter is a Money::LiveConverter instance.
    # params:
    # +money_live_converter+:: An object derived from Money::LiveConverter
    # returns:
    # An object derived from Money::LiveConverter 
    ############################################################################
    def self.sanitize_money_live_converter(money_live_converter)
      raise "The arithemtic operation can only be done on a Money::LiveConverter instance (Money::LiveConverter.new(4,'EUR'))." unless money_live_converter.is_a?(Money::LiveConverter)
      money_live_converter
    end

	end
end