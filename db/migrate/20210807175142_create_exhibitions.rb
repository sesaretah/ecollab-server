class CreateExhibitions < ActiveRecord::Migration[5.2]
  def change
    create_table :exhibitions do |t|
      t.string :title
      t.string :info
      t.integer :event_id

      t.timestamps
    end
    add_index :exhibitions, :event_id
  end
end
