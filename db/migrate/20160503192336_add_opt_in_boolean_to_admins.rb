class AddOptInBooleanToAdmins < ActiveRecord::Migration[5.0]
  def change
    add_column :cms_admins, :opt_in_to_emails, :boolean, default: true
  end
end
