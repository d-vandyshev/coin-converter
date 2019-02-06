require 'rails_helper'

RSpec.describe 'Coin Converter API', type: :request do
  path '/cryptocurrencies' do
    get 'Retrieves all cryptocurrencies' do
      tags 'Cryptocurrencies'
      produces 'application/json'

      response '200', 'successful operation' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   name: { type: :string, example: 'Bitcoin' },
                   symbol: { type: :string, example: 'BTC' },
                   price_usd: { type: :number, format: :float, example: 3467.12651186 }
                 },
                 required: %w[name symbol price_usd]
               }
        run_test!
      end
    end
  end

  path '/conversions' do
    get 'Retrieves conversions' do
      tags 'Cryptocurrencies'
      produces 'application/json'
      parameter name: :limit, in: :query, type: :integer, description: 'number of records to return', default: 10

      response '200', 'successful operation' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   from_currency: { type: :string, example: 'Bitcoin' },
                   to_currency: { type: :string, example: 'Ethereum' },
                   amount: { type: :number, format: :float, example: 1.25 },
                   created_at: { type: :string, format: :'date-time', example: '2019-02-01T15:35:28.898Z' }
                 },
                 required: %w[from_currency to_currency amount created_at]
               }
        run_test!
      end
    end

    post 'Creates a coinversion' do
      tags 'Cryptocurrencies'
      produces 'application/json'
      parameter name: :body, in: :body, description: 'place for request data', required: true, schema: {
        type: :object,
        properties: {
          conversion: {
            type: :object,
            properties: {
              from_currency: { type: :string, example: 'Bitcoin' },
              to_currency: { type: :string, example: 'Ethereum' },
              amount: { type: :number, format: :float, example: 1.25 }
            },
            required: %w[from_currency to_currency amount]
          }
        }
      }

      response '200', 'successful convert' do
        schema type: :object,
               properties: {
                 cost: { type: :number, format: :float, example: 4.75 }
               }
        run_test!
      end
    end
  end
end
