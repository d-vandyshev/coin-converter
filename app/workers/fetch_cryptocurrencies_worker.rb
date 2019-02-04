require 'sidekiq-scheduler'

class FetchCryptocurrenciesWorker
  include Sidekiq::Worker

  def perform
    sidekiq_retries_exhausted_block do |msg, _|
      Sidekiq.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
    end

    fetch_cryptocurrencies
    @currencies_from_db = Cryptocurrency.all
    if @currencies_from_db.empty?
      Cryptocurrency.import @currencies_from_api
      return
    end
    add_new_cryptocurrencies
    update_exist_cryptocurrencies
  end

  private

  def fetch_cryptocurrencies
    api = Rails.configuration.x.api_coinmarketcap
    body = request_coinmarketcap(api.url, api.params, api.headers)

    @currencies_from_api = []
    parse_json_currencies(body).each do |cur|
      @currencies_from_api << { name: cur[:name], symbol: cur[:symbol], price_usd: cur.dig(:quote, :USD, :price) }
    end
  end

  def request_coinmarketcap(url, params, headers)
    connect = Typhoeus::Request.new(url, params: params, headers: headers)
    connect.run
    connect.response.body
  end

  def parse_json_currencies(body)
    JSON.parse(body, symbolize_names: true).fetch[:data]
  end

  def add_new_cryptocurrencies
    names_db = @currencies_from_db.pluck(:name)
    Cryptocurrency.import(@currencies_from_api.reject { |cc| names_db.include?(cc) })
  end

  def update_exist_cryptocurrencies
    for_update = {}
    @currencies_from_api.each do |api|
      @currencies_from_db.each do |bd|
        if bd[:name] == api[:name] && bd[:price_usd] != api[:price_usd]
          for_update[bd[:id]] = { price_usd: api[:price_usd] }
        end
      end
    end
    Cryptocurrency.update(for_update.keys, for_update.values)
  end
end
