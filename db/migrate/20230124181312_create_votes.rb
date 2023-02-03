class CreateVotes < ActiveRecord::Migration[6.1]
  def change
    create_table :votes do |t|
      t.belongs_to :votable, polymorphic: true
      t.integer :val

      t.timestamps
    end
    add_reference(:votes, :author, foreign_key: { to_table: :users })
  end
end
