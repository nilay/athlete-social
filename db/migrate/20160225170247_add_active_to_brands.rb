class AddActiveToBrands < ActiveRecord::Migration[5.0]
  def change
    add_column :brands, :active, :boolean, default: false
  end
end
