# Preview all emails at http://localhost:3000/rails/mailers/author_of_question
class AuthorOfQuestionPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/author_of_question/notify
  def notify
    AuthorOfQuestionMailer.notify
  end

end
