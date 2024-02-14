# frozen_string_literal: true
class Notify
  def notify_author_of_question(answer)
    AuthorOfQuestionMailer.notify(answer.question.author, answer).deliver_later
  end
end
