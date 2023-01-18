class CreateRewards < ActiveRecord::Migration[6.1]
  def change
    create_table :rewards do |t|
      t.string :name
      t.belongs_to :user
      t.belongs_to :question
      t.timestamps
    end
  end
end
