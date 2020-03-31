class CreateAvatars < ActiveRecord::Migration[5.0]
  def change
    create_table :avatars do |t|
      t.string :file_file_name
      t.string :file_content_type
      t.integer :file_file_size
      t.string :avatar_owner_type
      t.integer :avatar_owner_id
      t.timestamps
    end
  end
end
