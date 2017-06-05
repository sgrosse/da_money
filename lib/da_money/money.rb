module DaMoney
  class Money

    class << self

      # Reads and returns the configuration file with the conversion rates.
      #
      # @return [Hash]
      def conversion_rates
        @conversion_rates ||= File.exist?('config/conversion_rates.yml') ? \
          YAML.load_file('config/conversion_rates.yml') : \
          raise(Exception.new("'config/conversion_rates.yml' does not seem to exist, " +
            "check README for details!"))
      end

    end

    # Creates a new DaMoney::Money object with a given amount in a given currency.
    # The amount is converted to a Float and rounded to two decimal places.
    # The currency is converted to a String.
    #
    # @return [DaMoney::Money]
    def initialize(amount, currency)
      raise Exception.new("'amount' must be a Numeric!") unless amount.is_a? Numeric
      @amount = amount.to_f.round(2)
      @currency = currency.to_s
    end

    # Returns the numerical value of a DaMoney::Money object.
    #
    # @return [Float]
    def amount
      @amount
    end

    # Returns the the currency of a DaMoney::Money object.
    #
    # @return [String]
    def currency
      @currency
    end

    # Converts a DaMoney::Money object into a different currency.
    #
    # @return [DaMoney::Money]
    def convert_to(target_currency)
      raise Exception.new("'target_currency' must be different from the current currency!") \
        if target_currency == self.currency
      result = self.amount * conversion_rate(target_currency)
      DaMoney::Money.new(result, target_currency)
    end

    # Returns the conversion rate from the current currency to a target currency.
    # Checks if the current currency is configured as a base currency and
    # and if it contains a rate for the target currency.
    # 
    # @return [Float]
    def conversion_rate(target_currency)
      if DaMoney::Money.conversion_rates.key? self.currency
        if DaMoney::Money.conversion_rates[self.currency].key? target_currency
          DaMoney::Money.conversion_rates[self.currency][target_currency].to_f
        else
          raise Exception.new("Conversion rate from '#{self.currency}' to '#{target_currency}'" +
            " if not configured!")
        end
      else
        raise Exception.new("Curreny '#{self.currency}' is not configured!")
      end
    end

    # Returns the string representation of a DaMoney::Money object.
    # Amounts are always formated to two decimals.
    #
    # @return [String]
    def inspect
      "#{'%.2f' % self.amount} #{self.currency}"
    end

    # Defines comparison operations for a DaMoney::Money object.
    # A DaMoney::Money object can only be compared to another DaMoney::Money object.
    # The DaMoney::Money object given will be converted to the base currency if necessary.
    #
    # @return [Boolean]
    %w(== >= <= < >).each do |m|
      define_method m do |money|
        raise Exception.new("'money' must be a DaMoney::Money object!") \
          unless money.is_a? DaMoney::Money
        money = money.convert_to(self.currency) unless self.currency == money.currency
        self.amount.send(m, money.amount)
      end
    end

    # Defines mathematical operations '*' and '/' for a DaMoney::Money object.
    # A DaMoney::Money object can be multiplied and divided by a Numeric.
    #
    # @return [DaMoney::Money]
    %w(* /).each do |m|
      define_method m do |number|
        raise Exception.new("'number' must be a Numeric!") \
          unless number.is_a? Numeric
        result = self.amount.send(m, number)
        DaMoney::Money.new(result, self.currency)
      end
    end

    # Defines mathematical operations '+' and '-' for a DaMoney::Money object.
    # A DaMoney::Money object can be added, subtracted by another DaMoney::Money object.
    # The DaMoney::Money object given will be converted to the base currency if necessary.
    #
    # @return [DaMoney::Money]
    %w(+ -).each do |m|
      define_method m do |money|
        raise Exception.new("'money' must be a DaMoney::Money object!") \
          unless money.is_a? DaMoney::Money
        money = money.convert_to(self.currency) unless self.currency == money.currency
        result = self.amount.send(m, money.amount)
        DaMoney::Money.new(result, self.currency)
      end
    end

  end
end
