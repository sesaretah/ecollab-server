class CreateMeetings < ActiveRecord::Migration[5.2]
  def change
    create_table :meetings do |t|
      t.string :title
      t.text :info
      t.integer :event_id
      t.string :meeting_type
      t.datetime :start_time
      t.datetime :end_time
      t.string :location
      t.boolean :is_private

      t.timestamps
    end
    add_index :meetings, :event_id
  end
end
