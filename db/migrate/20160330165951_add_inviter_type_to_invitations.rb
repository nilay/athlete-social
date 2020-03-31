class AddInviterTypeToInvitations < ActiveRecord::Migration[5.0]
  def change
    add_column :invitations, :inviter_type, :integer, default: 0
  end
end
