class AddDutyToAttendances < ActiveRecord::Migration[5.2]
  def change
    add_column :attendances, :duty, :string
    add_index :attendances, :duty
  end
end
