class AddAccountStatus < ActiveRecord::Migration[5.0]
  def change
    add_column :athletes, :account_status, :integer, default: 0
    add_column :fans, :account_status, :integer, default: 0
    add_column :cms_admins, :account_status, :integer, default: 0
    add_column :brand_users, :account_status, :integer, default: 0
  end
end
