class AddCurrentRoleIdToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :current_role_id, :integer
  end
end
