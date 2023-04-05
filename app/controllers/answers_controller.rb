class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index]
  before_action :find_question, only: %i[index new create]
  before_action :load_answers, only: %i[index]
  before_action :find_answer, only: %i[destroy purge_file update best]
  after_action :publish_answer, only: %i[create]

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
    @answer.update(answer_params)
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
    @question.reward_best_answer
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

  def respond_answer_json
    { user_id: current_user.id,
      id: @answer.id.to_s,
      body: @answer.body,
      files: attached_files,
      links: @answer.links,
      author_id: @answer.author_id,
      question_author_id: @question.author_id,
      votes_value: @answer.votes_value,
      like_link: like_answer_path(@answer),
      dislike_link: dislike_answer_path(@answer),
      best_link: best_answer_path(@answer) }
  end

  def publish_answer
    return if @answer.errors.any?

    AnswersChannel.broadcast_to(
      @question,
      respond_answer_json
    )
  end

  def attached_files
    return [] unless @answer.files.any?

    @answer.files.map { |file| { id: file.id, name: file.filename.to_s, url: url_for(file) } }
  end

  def answer_params
    params.require(:answer).permit(:body, :file_id, files: [], links_attributes: %i[name url id _destroy])
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
