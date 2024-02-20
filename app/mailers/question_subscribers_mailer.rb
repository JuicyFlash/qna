class QuestionSubscribersMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.question_subscribers_mailer.notify.subject
  #
  def notify(question_subscriber)
    @greeting = 'You have new answer'
    mail to: question_subscriber.email
  end
end
