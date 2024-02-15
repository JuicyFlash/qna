# frozen_string_literal: true
class Notify
  def notify_question_subscribers(question)
    question.subscriptions.find_each do |sub|
      QuestionSubscribersMailer.notify(sub.subscriber).deliver_later
    end
  end
end
