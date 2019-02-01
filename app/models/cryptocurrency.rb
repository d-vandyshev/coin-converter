class Cryptocurrency < ApplicationRecord

  has_many :from_currencies, class_name: 'Conversion', foreign_key: 'from_currency_id'
  has_many :to_currencies, class_name: 'Conversion', foreign_key: 'to_currency_id'

  validates :name, :symbol, :price_usd, presence: true
  validates :name, :symbol, length: { maximum: 128 }
  validates :price_usd, numericality: true
end
