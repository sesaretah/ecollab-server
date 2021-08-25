class CreatePollings < ActiveRecord::Migration[5.2]
  def change
    create_table :pollings do |t|
      t.integer :poll_id
      t.integer :user_id
      t.integer :outcome

      t.timestamps
    end
    add_index :pollings, :poll_id
    add_index :pollings, :user_id
  end
end
