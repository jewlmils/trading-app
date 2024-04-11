class CreateTransactions < ActiveRecord::Migration[7.1]
  def change
    create_table :transactions do |t|
      t.references :trader, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.references :portfolio, null: false, foreign_key: true
      t.string :transaction_type
      t.integer :number_of_shares
      t.decimal :price

      t.timestamps
    end
  end
end
