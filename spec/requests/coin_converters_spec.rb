require 'rails_helper'

RSpec.describe "CoinConverters", type: :request do
  describe "GET /coin_converters" do
    it "works! (now write some real specs)" do
      get coin_converters_path
      expect(response).to have_http_status(200)
    end
  end
end
