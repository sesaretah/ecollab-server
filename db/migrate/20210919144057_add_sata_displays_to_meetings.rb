class AddSataDisplaysToMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :sata_displays, :json
  end
end
