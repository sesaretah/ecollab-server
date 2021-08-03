class CreateIcons < ActiveRecord::Migration[5.2]
  def change
    create_table :icons do |t|
      t.text :content
      t.string :title

      t.timestamps
    end
  end
end
