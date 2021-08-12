class AddUserIdToExhibition < ActiveRecord::Migration[5.2]
  def change
    add_column :exhibitions, :user_id, :integer
    add_index :exhibitions, :user_id
  end
end
