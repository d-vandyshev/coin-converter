class CryptocurrenciesController < ApplicationController
  def index
    render json: Cryptocurrency.all, only: [:name, :symbol, :price_usd]
  end
end
