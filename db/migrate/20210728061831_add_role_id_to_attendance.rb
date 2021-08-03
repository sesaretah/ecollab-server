class AddRoleIdToAttendance < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :role_id, :integer
    add_index :attendances, :role_id
  end
end
