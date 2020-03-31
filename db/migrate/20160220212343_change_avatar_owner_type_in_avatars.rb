class ChangeAvatarOwnerTypeInAvatars < ActiveRecord::Migration[5.0]
  def change
    remove_column :avatars, :avatar_owner_type
    add_column :avatars, :avatar_owner_type, :integer
  end
end
