class CreateAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances do |t|
      t.integer :user_id
      t.integer :attendable_id
      t.string :attendable_type
      t.integer :label_id

      t.timestamps
    end
    add_index :attendances, :user_id
    add_index :attendances, :attendable_id
    add_index :attendances, :attendable_type
    add_index :attendances, :label_id
  end
end
