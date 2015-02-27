class RatesController < ApplicationController

  def index
    render json: CurrencyMarket.rates
  end

end
