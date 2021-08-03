class CreateTaggings < ActiveRecord::Migration[5.2]
  def change
    create_table :taggings do |t|
      t.integer :taggable_id
      t.string :taggable_type
      t.integer :tag_id

      t.timestamps
    end
    add_index :taggings, :taggable_id
    add_index :taggings, :taggable_type
  end
end
