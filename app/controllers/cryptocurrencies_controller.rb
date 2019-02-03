class CryptocurrenciesController < ApplicationController
  def index
    render json: Cryptocurrency.all, only: %i[name symbol price_usd]
  end
end
