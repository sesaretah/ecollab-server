class AddVuuidToRoom < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :vuuid, :string
  end
end
