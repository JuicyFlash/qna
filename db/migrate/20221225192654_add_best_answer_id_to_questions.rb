class AddBestAnswerIdToQuestions < ActiveRecord::Migration[6.1]
  def change
    add_reference(:questions, :best_answer, to_table: :answers)
  end
end
