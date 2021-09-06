class AddShortnameToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :shortname, :string
    add_index :events, :shortname
  end
end
