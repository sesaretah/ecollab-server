class AddAnswerTypeToPoll < ActiveRecord::Migration[5.2]
  def change
    add_column :polls, :answer_type, :string
  end
end
