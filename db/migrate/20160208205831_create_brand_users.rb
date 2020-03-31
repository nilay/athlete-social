class CreateBrandUsers < ActiveRecord::Migration[5.0]
  # This migration comes from challah_engine (originally 20120127150433)
  def up
    create_table :brand_users do |t|
      t.string      :first_name
      t.string      :last_name
      t.string      :email
      t.string      :email_hash
      t.string      :persistence_token
      t.string      :api_key
      t.integer     :role_id, default: 0 # Not used by default, install challah-rolls to utilize this
      t.datetime    :last_session_at
      t.string      :last_session_ip
      t.integer     :session_count, default: 0
      t.integer     :failed_auth_count, default: 0
      t.integer     :created_by, default: 0
      t.integer     :updated_by, default: 0
      t.datetime    :created_at
      t.datetime    :updated_at
      t.boolean     :active, default: true
      t.timestamps  null: true
    end

    add_index :brand_users, :first_name
    add_index :brand_users, :last_name
    add_index :brand_users, :email
    add_index :brand_users, :api_key
    add_index :brand_users, :role_id
  end

  def down
    drop_table :brand_users
  end
end
