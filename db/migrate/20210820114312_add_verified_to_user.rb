class AddVerifiedToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :verified, :boolean
    add_index :users, :verified
  end
end
