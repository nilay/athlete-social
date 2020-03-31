class AddPhoneNumberToInvitation < ActiveRecord::Migration[5.0]
  def change
    add_column :invitations, :phone_number, :string
  end
end
