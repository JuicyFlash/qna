class AnswersController < ApplicationController
  before_action :authenticate_user!, except: %i[index]
  before_action :find_question, only: %i[index new create]
  before_action :load_answers, only: %i[index]
  before_action :find_answer, only: %i[destroy purge_file update best]

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
    @answer.files.attach(answer_params[:files]) unless answer_params[:files].nil?
    @answer.update(body: answer_params[:body])
    @question = @answer.question
    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
  end

  def best
    @question = @answer.question
    @old_best_answer = @question.best_answer
    if @question.best_answer_id == @answer.id
      @question.best_answer_id = nil
      @best_answer = nil
    else
      @question.best_answer_id = @answer.id
      @best_answer = @answer
    end
    @question.save
  end

  def purge_file
    @file = @answer.files.find(params[:file_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to @answer.question, { alert: 'Файл не найден' }
  else
    @file.purge
  end

  private

  def answer_params
    params.require(:answer).permit(:body, :file_id, files: [])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def find_question
    @question = Question.with_attached_files.find(params[:question_id])
  end

  def load_answers
    @answers = @question.answers
  end

end
