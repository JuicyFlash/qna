class AnswersChannel < ApplicationCable::Channel
  def follow
    stream_for question
  end

  private

  def question
    Question.find_by(id: params[:room_id])
  end
end
