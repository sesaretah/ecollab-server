class AddCapacityToMeeting < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :capacity, :integer
  end
end
