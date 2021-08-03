class CreateLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :labels do |t|
      t.string :title
      t.string :color
      t.integer :icon_id

      t.timestamps
    end
    add_index :labels, :icon_id
  end
end
