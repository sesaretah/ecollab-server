class AddUuidToUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :uuid, :string
    add_index :uploads, :uuid
  end
end
