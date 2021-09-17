class AddSocialToProfile < ActiveRecord::Migration[5.2]
  def change
    add_column :profiles, :twitter, :string
    add_column :profiles, :linkdin, :string
    add_column :profiles, :email, :string
    add_column :profiles, :instagram, :string
    add_column :profiles, :telegram, :string
    add_column :profiles, :phone, :string
  end
end
