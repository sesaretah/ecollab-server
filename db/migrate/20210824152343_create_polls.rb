class CreatePolls < ActiveRecord::Migration[5.2]
  def change
    create_table :polls do |t|
      t.integer :pollable_id
      t.string :pollable_type
      t.string :content

      t.timestamps
    end
    add_index :polls, :pollable_id
    add_index :polls, :pollable_type
  end
end
