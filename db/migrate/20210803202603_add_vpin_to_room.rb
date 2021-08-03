class AddVpinToRoom < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :vpin, :string
  end
end
