class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :title
      t.text :description
      t.integer :user_id
      t.boolean :private

      t.timestamps
    end
    add_index :rooms, :user_id
  end
end
