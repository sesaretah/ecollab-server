class AddCropSettingsToUpload < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :crop_settings, :json
  end
end
