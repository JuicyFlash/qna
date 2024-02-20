class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|

      t.belongs_to :subscrible, polymorphic: true
      t.timestamps
    end

    add_reference(:subscriptions, :subscriber, foreign_key: { to_table: :users })
  end
end
