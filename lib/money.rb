require "money/version"
require "money/input_sanitizer"
require "money/cross_rate"

module Money
	class LiveConverter
		attr_accessor :amount
		attr_reader :currency
		
		#####################################################
		# Basic Constructor:
		# Call with Money::LiveConverter.new(amount,currency) 
		# params:
 		# +amount+:: Is a positive number reprasenting the money amount of this object
		# +currency+:: Is a 3 char length based string (ISO 4217) representing 
		# 				this object is holding 
		# +options+:: An option hash for future purpose.
		####################################################
		def initialize(amount=1,currency='EUR',opt={})
		  Money::CrossRate.conversion_rates if Money::CrossRate.currency.nil? && Money::CrossRate.cross_rate.nil?
			begin
				@amount = Money::InputSanitizer.sanitize_amount(amount)
				@currency = Money::InputSanitizer.sanitize_currency(currency,Money::CrossRate.get_all_available_currencies)		
			rescue RuntimeError => e
				puts "#{e.message}"
				@amount = nil
				@currency = nil
			end
		end
		
		####################################################
		# Overriding original inspect and returning a String representation of the
		# Money::LiveConverter instance
		####################################################
		def inspect
			"#{@amount} #{@currency}" if @amount && @currency
		end
    ###############################################################
    # Method sets the individuel cross_rate for a specific base currency value
    # params:
    # +currency+:: A String reprasenting the base currency value.
    # +cross_rate+:: A Hash in the manner of {'Currency' => Numeric_Value} 
    #                reprasenting the cross rate to the base currency value
    ###############################################################
		def self.conversion_rates(currency,cross_rate)
	     Money::CrossRate.conversion_rates(currency,cross_rate)
	  end
	  
	  ##################################################################
	  # Method converts the given amount of a Money::LiveConverter instance
	  # into a new Money::LiveConverter instance based on the exchange_currency 
	  # paramater. The new instance is returned if no errors happens during 
	  # the convertation.
	  # params:
	  # +exchange_currency+:: A String defining what currency instance
	  #                      is returned.
	  # returns:
	  # +Money::LiveConverter+: A new instance with the proper amount and
	  #                         currency tag. 
	  ##################################################################
	  def convert_to(exchange_currency)
	    begin
	       exchange_currency = Money::InputSanitizer.sanitize_currency(exchange_currency,Money::CrossRate.get_all_available_currencies)
	       Money::LiveConverter.new(@amount.to_f*Money::CrossRate.get_cross_value_for_currency(@currency,exchange_currency),exchange_currency)
	    rescue RuntimeError => e
	       puts "#{e.message}"
	    end
	  end
	  ###################################################################
	  # Overriding the plus operator by adding the amounts of each instance.
	  # If the amount of the second instance is in a different currency
	  # then the second instance call its convert_to function with the
	  # currency of the first instance.
	  # params:
	  # +money_live_convertor+:: An instance of Money::LiveConvertor which
	  #                          is going to be added to the first one.
	  ###################################################################
	  def +(money_live_convertor)
	    arithmetic_op('+',self,money_live_convertor)    
	  end
	  ###################################################################
    # Overriding the minus operator by subtracting the amounts of each instance.
    # If the amount of the second instance is in a different currency
    # then the second instance call its convert_to function with the
    # currency of the first instance.
    # params:
    # +money_live_convertor+:: An instance of Money::LiveConvertor which
    #                          is going to be subtracted to the first one.
    ###################################################################
	  def -(money_live_convertor)  
	    arithmetic_op('-',self,money_live_convertor)
	  end
	  ###################################################################
    # Overriding the multiplication operator by multiplying the amount
    # The amount of the second instance has to be a numeric
    # params:
    # +value+:: A numeric value multiplicated with the first instance amount
    ###################################################################
	  def *(value)
	    arithmetic_op('*',self,value,false)
	  end
	  
	  ####################################################################
    # Overriding the division operator by dividing the amount
    # The amount of the second instance has to be a numeric and not null
    # params:
    # +value+:: A numeric value dividing the first instance amount
    ###################################################################
    def /(value)
      arithmetic_op('/',self,value,false) unless value == 0
    end
	   
	  #####################################################################
    # Overriding the equality operator by comparing the instances amount
    # params:
    # +money_live_convertor+:: An instance of Money::LiveConvertor which
    #                          is going to be compared to the first one.
    ###################################################################
	  def ==(money_live_convertor)  
      arithmetic_op('==',self,money_live_convertor)
    end
	  
	  #####################################################################
    # Overriding the less operator by comparing the instances amount
    # params:
    # +money_live_convertor+:: An instance of Money::LiveConvertor which
    #                          is going to be compared to the first one.
    ###################################################################
	  def <(money_live_convertor)  
      arithmetic_op('<',self,money_live_convertor)
    end
    
    #####################################################################
    # Overriding the greater operator by comparing the instances amount
    # params:
    # +money_live_convertor+:: An instance of Money::LiveConvertor which
    #                          is going to be compared to the first one.
    ###################################################################
    def >(money_live_convertor)  
      arithmetic_op('>',self,money_live_convertor)
    end
	
	  private
	  #####################################################################
	  # Arithmethic fuction that does all the magic for the +,-,*,/,==,<,>
	  # operations. Based on http://stackoverflow.com/questions/13060239/send-and-math-operators
	  # the ruby public_send method is used to implement and interpret
	  # each operation correctly.
	  # params:
	  # +op+:: A String represanting one of +,-,*,/,==,<,> operations
	  # +ins_1+:: An Object which is used on the left hand side of the +op+ parameter
	  # +ins_2+:: An Object which is used on the right hand side of the +op+ parameter
	  # +do_sanitizing+:: A boolean flag defining whether a Money::LiveConverter instance
	  #                   has to be expected at +ins_2+ or not.
	  # returns:
	  # True for ==,<,> operations and a new Money::LiveConverter instance for +,-,*,/
    #####################################################################
	  def arithmetic_op(op,ins_1,ins_2,do_sanitizing=true)
      begin
        amount = ''
        if do_sanitizing
          ins_2 = Money::InputSanitizer.sanitize_money_live_converter(ins_2)
          if ( ins_1.currency == ins_2.currency )
            amount = ins_1.amount.to_f.public_send(op,ins_2.amount.to_f)
          else
            amount = ins_1.amount.to_f.public_send(op,ins_2.convert_to(ins_1.currency).amount.to_f)
          end
        else
            amount = ins_1.amount.to_f.public_send(op,ins_2.to_f)
        end
        if (['==','<','>'].include?(op))
          return amount
        else
          Money::LiveConverter.new(amount,ins_1.currency)
        end
      rescue RuntimeError => e
         puts "#{e.message}"
      end
    end
	end  
end
