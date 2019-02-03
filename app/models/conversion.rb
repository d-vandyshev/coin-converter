class Conversion < ApplicationRecord

  belongs_to :from_currency, class_name: 'Cryptocurrency'
  belongs_to :to_currency, class_name: 'Cryptocurrency'

  validates :from_currency_id, :to_currency_id, numericality: {only_integer: true, greater_than: 0}
  validates :amount, numericality: {greater_than: 0}

  scope :list_last, ->(length) {Conversion.includes(:from_currency, :to_currency).last(length)}
end
