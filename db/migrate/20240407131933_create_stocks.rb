class CreateStocks < ActiveRecord::Migration[7.1]
  def change
    create_table :stocks do |t|
      t.string :ticker_symbol
      t.string :company_name
      t.decimal :price

      t.timestamps
    end

    add_index :stocks, :ticker_symbol, unique: true
  end
end
