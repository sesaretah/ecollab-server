class CreateSubscribers < ActiveRecord::Migration[5.2]
  def change
    create_table :subscribers do |t|
      t.integer :user_id
      t.integer :room_id
      t.string :rfid
      t.string :current_mode

      t.timestamps
    end
    add_index :subscribers, :user_id
    add_index :subscribers, :room_id
    add_index :subscribers, :rfid
    add_index :subscribers, :current_mode
  end
end
