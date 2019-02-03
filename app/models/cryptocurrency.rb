class Cryptocurrency < ApplicationRecord
  has_many :from_conv_currencies,
           class_name: 'Conversion',
           foreign_key: 'from_currency_id',
           dependent: :restrict_with_exception,
           inverse_of: :from_currency

  has_many :to_conv_currencies,
           class_name: 'Conversion',
           foreign_key: 'to_currency_id',
           dependent: :restrict_with_exception,
           inverse_of: :to_currency

  validates :name, :symbol, :price_usd, presence: true
  validates :name, :symbol, length: { maximum: 128 }
  validates :price_usd, numericality: { greater_than: 0 }
end
