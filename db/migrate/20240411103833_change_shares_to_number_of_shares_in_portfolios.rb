class ChangeSharesToNumberOfSharesInPortfolios < ActiveRecord::Migration[7.1]
  def change
    rename_column :portfolios, :shares, :number_of_shares
  end
end
