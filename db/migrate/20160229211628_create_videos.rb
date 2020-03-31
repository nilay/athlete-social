class CreateVideos < ActiveRecord::Migration[5.0]
  def change
    create_table :videos do |t|
      t.integer :post_id
      t.string :thumbnail_url
      t.string :base_url
      t.timestamps
    end
    add_index :videos, :post_id
  end
end
