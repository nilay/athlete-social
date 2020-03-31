class AddIsUploadedToAvatars < ActiveRecord::Migration[5.0]
  def change
    add_column :avatars, :is_uploaded, :boolean, default: false
  end
end
