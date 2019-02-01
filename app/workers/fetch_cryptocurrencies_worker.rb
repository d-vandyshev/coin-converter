require 'sidekiq-scheduler'

class FetchCryptocurrenciesWorker
  include Sidekiq::Worker

  def perform
    sidekiq_retries_exhausted_block do |msg, ex|
      Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
    end

    fetch_cryptocurrencies
    if Cryptocurrency.first.nil?
      Cryptocurrency.import @cryptocurrencies
      return
    end
    add_new_cryptocurrencies
    remove_missing_cryptocurrencies
    update_existing_cryptocurrencies
  end

  private

  def fetch_cryptocurrencies
    c = Rails.configuration.x.api_coinmarketcap
    connect = Typhoeus::Request.new(c.url, params: c.params, headers: c.headers)
    connect.run
    json = JSON.parse(connect.response.body, {symbolize_names: true}) # need to rescue

    @cryptocurrencies = []
    json[:data].each do |c|
      @cryptocurrencies << {name: c[:name], symbol: c[:symbol], price_usd: c.dig(:quote, :USD, :price)}
    end
  end

  def add_new_cryptocurrencies
    @cryptocurrencies.each do |c|
      if Cryptocurrency.not_exists? name: c[:name]
        Cryptocurrency.create(name: c[:name], symbol: c[:symbol], price_usd: c[:price_usd])
      end
    end
  end

  def update_existing_cryptocurrencies
    @cryptocurrencies.each do |cf|
      Cryptocurrency.all.each do |cdb|
        if cdb.name == cf[:name]
          cdb.update(symbol: cf[:symbol], price_usd: cf[:price_usd])
        end
      end
    end
  end
end
