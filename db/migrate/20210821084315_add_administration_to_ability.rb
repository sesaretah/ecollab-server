class AddAdministrationToAbility < ActiveRecord::Migration[5.2]
  def change
    add_column :abilities, :administration, :boolean
  end
end
