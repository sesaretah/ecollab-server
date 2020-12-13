class CreateParticipations < ActiveRecord::Migration[5.2]
  def change
    create_table :participations do |t|
      t.integer :room_id
      t.integer :user_id
      t.string :device_id
      t.string :current_role
      t.string :uuid
      t.json :activity_logs

      t.timestamps
    end
    add_index :participations, :current_role
    add_index :participations, :uuid
  end
end
