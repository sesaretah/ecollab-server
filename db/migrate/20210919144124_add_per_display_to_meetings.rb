class AddPerDisplayToMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :per_display, :integer
  end
end
