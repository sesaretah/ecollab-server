class AddIsDefaultToFlyers < ActiveRecord::Migration[5.2]
  def change
    add_column :flyers, :is_default, :boolean
  end
end
