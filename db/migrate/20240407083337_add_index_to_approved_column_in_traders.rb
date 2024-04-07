class AddIndexToApprovedColumnInTraders < ActiveRecord::Migration[7.1]
  def change
    add_index :traders, :approved
  end
end
