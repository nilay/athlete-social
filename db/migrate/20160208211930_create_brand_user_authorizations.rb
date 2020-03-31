class CreateBrandUserAuthorizations < ActiveRecord::Migration[5.0]
  def change
    create_table :brand_user_authorizations do |t|
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

    add_index :brand_user_authorizations, :user_id
    add_index :brand_user_authorizations, [ :user_id, :provider ]
    add_index :brand_user_authorizations, :uid
    add_index :brand_user_authorizations, :token
  end
end
