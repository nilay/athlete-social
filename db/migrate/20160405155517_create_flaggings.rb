class CreateFlaggings < ActiveRecord::Migration[5.0]
  def change
    create_table :flaggings do |t|
      t.integer :post_id
      t.integer :flagger_id
      t.integer :flagger_type
      t.integer :moderator_id
      t.integer :status
      t.timestamp :status_changed_at
      t.timestamps
    end
  end
end
