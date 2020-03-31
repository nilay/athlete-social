class CreateImages < ActiveRecord::Migration[5.0]
  def change
    create_table :images do |t|
      t.integer :post_id
      t.timestamps
    end
    add_index :images, :post_id
  end
end
