class CreateDiscussions < ActiveRecord::Migration[5.2]
  def change
    create_table :discussions do |t|
      t.integer :discussable_id
      t.string :discussable_type
      t.string :title
      t.string :discussion_type
      t.boolean :is_private

      t.timestamps
    end
    add_index :discussions, :discussable_id
    add_index :discussions, :discussable_type
  end
end
