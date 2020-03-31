class AddNameToInvitations < ActiveRecord::Migration[5.0]
  def change
    add_column :invitations, :invitee_name, :string
  end
end
