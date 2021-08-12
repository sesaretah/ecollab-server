class AddUploadTypeToUpload < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :upload_type, :string
    add_index :uploads, :upload_type
  end
end
