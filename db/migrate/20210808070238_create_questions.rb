class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :content
      t.string :questionable_type
      t.integer :questionable_id
      t.integer :user_id

      t.timestamps
    end
    add_index :questions, :questionable_type
    add_index :questions, :questionable_id
    add_index :questions, :user_id
  end
end
