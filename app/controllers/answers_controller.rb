class AnswersController < ApplicationController
  before_action :find_question, only: %i[index new create]
  before_action :load_answers, only: %i[index]

  def index; end

  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    if @answer.save
      redirect_to question_answers_path @question
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def load_answers
    @answers = @question.answers
  end
end
