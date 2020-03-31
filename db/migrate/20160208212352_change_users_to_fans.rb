class ChangeUsersToFans < ActiveRecord::Migration[5.0]
  def change
    rename_table :users, :fans
    rename_table :authorizations, :fan_authorizations
  end
end
