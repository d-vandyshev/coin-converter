class CreateConversions < ActiveRecord::Migration[5.2]
  def change
    create_table :conversions do |t|
      t.references :from_currency
      t.references :to_currency
      t.float :amount

      t.timestamps
    end
    add_foreign_key :conversions, :cryptocurrencies, column: :from_currency_id, primary_key: :id
    add_foreign_key :conversions, :cryptocurrencies, column: :to_currency_id, primary_key: :id
  end
end
