class AddAttendeePasswordToRoom < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :attendee_password, :string
  end
end
