class AddBigblueToMeeting < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :bigblue, :boolean
  end
end
