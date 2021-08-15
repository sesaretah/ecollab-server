class AddIsPrivateToQuestions < ActiveRecord::Migration[5.2]
  def change
    add_column :questions, :is_private, :boolean
  end
end
