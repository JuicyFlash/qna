class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index]
  before_action :find_question, only: %i[index new create]
  before_action :load_answers, only: %i[index]
  before_action :find_answer, only: %i[destroy]

  def index; end

  def new
    @answer = current_user.answers.new
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author_id = current_user.id
    @answer.save
  end

  def destroy
    @question = @answer.question
    @answer.destroy if @answer.author_id == current_user.id
  end

  def update
    @answer = Answer.find(params[:id])
    @answer.update(answer_params)
    @question = @answer.question
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def load_answers
    @answers = @question.answers
  end

end
