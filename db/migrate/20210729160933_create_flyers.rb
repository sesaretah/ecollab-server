class CreateFlyers < ActiveRecord::Migration[5.2]
  def change
    create_table :flyers do |t|
      t.string :title
      t.text :content
      t.integer :user_id
      t.integer :advertisable_id
      t.string :advertisable_type

      t.timestamps
    end
    add_index :flyers, :user_id
    add_index :flyers, :advertisable_id
    add_index :flyers, :advertisable_type
  end
end
