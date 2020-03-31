class CreateCmsAdminAuthorizations < ActiveRecord::Migration[5.0]
  def change
    create_table :cms_admin_authorizations do |t|
      t.integer     :user_id
      t.string      :provider, limit: 50
      t.string      :uid
      t.string      :token, limit: 500
      t.datetime    :expires_at
      t.datetime    :last_session_at
      t.string      :last_session_ip
      t.integer     :session_count, default: 0
      t.timestamps  null: true
      t.timestamps
      t.timestamps
    end

    add_index :cms_admin_authorizations, :user_id
    add_index :cms_admin_authorizations, [ :user_id, :provider ]
    add_index :cms_admin_authorizations, :uid
    add_index :cms_admin_authorizations, :token
  end
end
