class CreateBlockings < ActiveRecord::Migration[5.0]
  def change
    create_table :blockings do |t|
      t.integer :blocker_id
      t.integer :blocker_type
      t.integer :blocked_user_id
      t.integer :blocked_user_type
      t.timestamps
    end
  end
end
