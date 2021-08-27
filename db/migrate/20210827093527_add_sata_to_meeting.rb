class AddSataToMeeting < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :sata, :boolean
  end
end
