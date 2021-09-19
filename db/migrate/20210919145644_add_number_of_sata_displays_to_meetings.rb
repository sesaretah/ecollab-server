class AddNumberOfSataDisplaysToMeetings < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :number_of_sata_displays, :integer
  end
end
