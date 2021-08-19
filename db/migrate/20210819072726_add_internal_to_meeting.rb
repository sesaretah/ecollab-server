class AddInternalToMeeting < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :internal, :boolean
  end
end
