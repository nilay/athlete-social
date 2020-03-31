class AddMoreIndexes < ActiveRecord::Migration[5.0]
  def change
    add_index :videos, :guid
    add_index :avatars, [:avatar_owner_id, :avatar_owner_type]
    add_index :invitations, :invite_token
    remove_index :invitations, :inviter_id
    add_index :invitations, [:inviter_id, :inviter_type]
    add_index :blockings, [:blocker_id, :blocker_type]
  end
end
