class AddSecretToRoom < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :secret, :string
  end
end
