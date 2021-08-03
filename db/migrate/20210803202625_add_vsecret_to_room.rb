class AddVsecretToRoom < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :vsecret, :string
  end
end
