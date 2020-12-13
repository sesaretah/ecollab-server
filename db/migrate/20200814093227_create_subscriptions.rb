class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.integer :room_id
      t.string :subscription_state

      t.timestamps
    end
  end
end
