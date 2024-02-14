class AuthorOfQuestionMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.author_of_question_mailer.notify.subject
  #
  def notify(question_author, answer)
    @greeting = 'You have new answer'
    @answer = answer
    mail to: question_author.email
  end
end
