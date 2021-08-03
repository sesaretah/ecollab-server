class AddIsPrivateToEvents < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :is_private, :boolean
    add_index :events, :is_private
  end
end
