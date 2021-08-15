class AddExhibitionIdToRoom < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :exhibition_id, :integer
    add_index :rooms, :exhibition_id
  end
end
