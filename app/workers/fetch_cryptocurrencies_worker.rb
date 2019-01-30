require 'sidekiq-scheduler'

class FetchCryptocurrenciesWorker
  include Sidekiq::Worker

  def perform
    # Do something
  end
end
