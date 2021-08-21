class AddModifyAbilityToAbility < ActiveRecord::Migration[5.2]
  def change
    add_column :abilities, :modify_ability, :boolean
  end
end
