class AddOutcomesToPoll < ActiveRecord::Migration[5.2]
  def change
    add_column :pollings, :outcomes, :json
  end
end
