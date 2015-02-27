module CurrencyMarket

  SOURCE = 'http://www.cbr.ru/scripts/XML_daily.asp'
  RATES  = {
    'GBP' => {
      nominal: 1,
      value: 54
    },
    'USD' => {
      nominal: 1,
      value: 33
    },
    'EUR' => {
      nominal: 1,
      value: 45
    }
  }

  def self.rates
    if data = Rails.cache.read(cache_key)
      data
    else
      data = fetch

      Rails.cache.write(cache_key, data, expires_in: 1.day)

      data
    end
  end

  private

    def self.cache_key
      "currency_market_at_#{Time.zone.now.strftime("%Y_%m_%d")}"
    end

    def self.fetch
      needed_rates = RATES.keys
      result       = HashWithIndifferentAccess.new

      begin
        raw_rates = HTTParty.get(SOURCE)['ValCurs']['Valute']

        raw_rates.each do |raw_rate|
          if RATES.include? raw_rate['CharCode']
            result[raw_rate['CharCode'].to_sym] = {
              nominal: raw_rate['Nominal'].to_i,
              value: raw_rate['Value'].gsub(',', '.').to_f
            }
          end
        end
      rescue Exception => e
        Rails.logger.error "CurrencyMarket: #{e.message}"
      ensure
        needed_rates.each do |rate|
          unless result.has_key? rate.to_sym
            result[rate.to_sym] = RATES[rate]
          end
        end
      end

      result
    end

end
