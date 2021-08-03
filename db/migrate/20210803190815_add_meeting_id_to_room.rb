class AddMeetingIdToRoom < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :meeting_id, :integer
    add_index :rooms, :meeting_id
  end
end
