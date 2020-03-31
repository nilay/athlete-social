class CreatePushNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :push_notifications do |t|
      t.string :message
      t.integer :status, default: 0
      t.jsonb :details, default: {}
      t.jsonb :result, default: {}
      t.timestamps
    end
    add_index :push_notifications, :details, using: :gin
    add_index :push_notifications, :result, using: :gin
    add_index :push_notifications, :status
  end
end
