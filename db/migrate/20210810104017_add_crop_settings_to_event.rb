class AddCropSettingsToEvent < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :crop_settings, :json
  end
end
