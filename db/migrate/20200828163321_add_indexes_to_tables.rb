class AddIndexesToTables < ActiveRecord::Migration[5.2]
  def change
    add_index :profiles, :user_id
    add_index :roles, :user_id
    add_index :devices, :user_id
    add_index :notification_settings, :user_id

    add_index :notifications, :notifiable_id
    add_index :notifications, :notifiable_type

  end
end
