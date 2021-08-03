class AddExternalLinkToMeeting < ActiveRecord::Migration[5.2]
  def change
    add_column :meetings, :external_link, :string
  end
end
