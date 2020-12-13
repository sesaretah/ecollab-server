class AddPinToRoom < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :pin, :string
  end
end
