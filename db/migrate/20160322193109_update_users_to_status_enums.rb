class UpdateUsersToStatusEnums < ActiveRecord::Migration[5.0]
  def change
    add_column :athletes, :status, :integer, default: 0
    add_column :fans, :status, :integer, default: 0
    add_column :brand_users, :status, :integer, default: 0
    add_column :cms_admins, :status, :integer, default: 0
  end
end
