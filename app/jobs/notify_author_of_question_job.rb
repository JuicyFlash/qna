# frozen_string_literal: true
class NotifyAuthorOfQuestionJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Notify.new.notify_author_of_question(answer)
  end
end
