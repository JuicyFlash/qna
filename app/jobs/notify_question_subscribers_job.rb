# frozen_string_literal: true
class NotifyQuestionSubscribersJob < ApplicationJob
  queue_as :default

  def perform(question)
    Notify.new.notify_question_subscribers(question)
  end
end
