class CreateAbilities < ActiveRecord::Migration[5.2]
  def change
    create_table :abilities do |t|
      t.integer :user_id
      t.boolean :create_event
      t.boolean :create_exhibition

      t.timestamps
    end
    add_index :abilities, :user_id
  end
end
