class AddModeratorPasswordToRoom < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :moderator_password, :string
  end
end
