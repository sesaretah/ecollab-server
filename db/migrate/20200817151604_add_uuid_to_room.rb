class AddUuidToRoom < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :uuid, :string
    add_index :rooms, :uuid
  end
end
