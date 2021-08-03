class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :title
      t.string :event_type
      t.text :info

      t.timestamps
    end
  end
end
