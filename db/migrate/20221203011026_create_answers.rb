class CreateAnswers < ActiveRecord::Migration[6.1]
  def change
    create_table :answers do |t|
      t.string :body

      t.timestamps
    end
    add_reference :answers, :question, foreign_key: true
  end
end
