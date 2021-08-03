class AddCountryToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :country, :string
  end
end
