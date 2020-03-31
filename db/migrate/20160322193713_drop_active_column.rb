class DropActiveColumn < ActiveRecord::Migration[5.0]
  def change
    remove_column :athletes, :active
    remove_column :fans, :active
    remove_column :brand_users, :active
    remove_column :cms_admins, :active
  end
end
