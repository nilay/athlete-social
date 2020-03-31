class ChangeActiveOnBrands < ActiveRecord::Migration[5.0]
  def change
    remove_column :brands, :active
    add_column :brands, :deactivated_at, :timestamp
  end
end
