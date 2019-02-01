class Conversion < ApplicationRecord

  belongs_to :from_currency, :class_name => "Cryptocurrency"
  belongs_to :to_currency,   :class_name => "Cryptocurrency"
end
