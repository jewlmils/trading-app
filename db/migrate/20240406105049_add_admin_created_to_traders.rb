class AddAdminCreatedToTraders < ActiveRecord::Migration[7.1]
  def change
    add_column :traders, :admin_created, :boolean
  end
end
