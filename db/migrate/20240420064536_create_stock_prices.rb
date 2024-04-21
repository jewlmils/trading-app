class CreateStockPrices < ActiveRecord::Migration[7.1]
  def change
    create_table :stock_prices do |t|
      t.date :date
      t.decimal :close_price
      t.decimal :current_price
      t.references :stock, null: false, foreign_key: true

      t.timestamps
    end
  end
end
