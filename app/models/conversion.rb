class Conversion < ApplicationRecord

  belongs_to :from_currency, class_name: 'Cryptocurrency'
  belongs_to :to_currency, class_name: 'Cryptocurrency'

  validate :from_currency_id, :to_currency_id, numericality: {only_integer: true, greater_than: 0}
  validate :amount, numericality: {greater_than: 0}
end
