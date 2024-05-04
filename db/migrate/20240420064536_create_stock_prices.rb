class CreateStockPrices < ActiveRecord::Migration[7.1]
  def change
    create_table :stock_prices do |t|
      t.date :date
      t.references :stock, null: false, foreign_key: true
      t.decimal :current_price

      t.timestamps
    end
  end
end
