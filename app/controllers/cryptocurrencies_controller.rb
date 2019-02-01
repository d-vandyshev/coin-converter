class CryptocurrenciesController < ApplicationController
  def index
    render json: Cryptocurrency.all.map { |c| {name: c.name, symbol: c.symbol, price_usd: c.price_usd} }
  end
end
