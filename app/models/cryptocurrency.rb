class Cryptocurrency < ApplicationRecord

  validates :name, :symbol, :price_usd, presence: true
  validates :name, :symbol, length: { maximum: 128 }
  validates :price_usd, numericality: true

end
