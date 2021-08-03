class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :title
      t.boolean :is_private
      t.string :uuid
      t.string :secret
      t.string :pin
      t.boolean :activated
      t.json :moderator_ids

      t.timestamps
    end
    add_index :rooms, :is_private
    add_index :rooms, :uuid
  end
end
