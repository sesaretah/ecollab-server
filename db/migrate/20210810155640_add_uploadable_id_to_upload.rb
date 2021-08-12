class AddUploadableIdToUpload < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :uploadable_id, :integer
    add_index :uploads, :uploadable_id
  end
end
