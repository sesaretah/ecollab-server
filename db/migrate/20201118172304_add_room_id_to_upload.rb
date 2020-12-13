class AddRoomIdToUpload < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :room_id, :integer
    add_index :uploads, :room_id
  end
end
