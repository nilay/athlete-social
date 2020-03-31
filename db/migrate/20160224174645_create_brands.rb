class CreateBrands < ActiveRecord::Migration[5.0]
  def change
    create_table :brands do |t|
      t.string :name
      t.text :description
      t.string :contact_name
      t.string :phone
      t.string :email
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :state
      t.string :postal_code
      t.timestamps
    end
    add_column :brand_users, :brand_id, :integer
    add_index :brand_users, :brand_id
  end
end
