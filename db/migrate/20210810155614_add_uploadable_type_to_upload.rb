class AddUploadableTypeToUpload < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :uploadable_type, :string
    add_index :uploads, :uploadable_type
  end
end
