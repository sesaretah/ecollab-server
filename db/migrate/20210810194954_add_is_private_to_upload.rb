class AddIsPrivateToUpload < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :is_private, :boolean
  end
end
