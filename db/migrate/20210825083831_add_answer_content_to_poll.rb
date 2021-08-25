class AddAnswerContentToPoll < ActiveRecord::Migration[5.2]
  def change
    add_column :polls, :answer_content, :json
  end
end
