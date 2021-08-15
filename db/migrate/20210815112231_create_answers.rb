class CreateAnswers < ActiveRecord::Migration[5.2]
  def change
    create_table :answers do |t|
      t.integer :question_id
      t.string :content
      t.integer :answer_id

      t.timestamps
    end
    add_index :answers, :question_id
    add_index :answers, :answer_id
  end
end
