class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy answer purge_file]
  after_action :publish_question, only: %i[create]

  def index
    gon_current_user
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
    @answer.links.new
    gon_current_user
  end

  def new
    @question = Question.new
    @question.links.new
    @question.reward = Reward.new
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      @created = true
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    if @question.author_id == current_user.id
      @question.destroy
      redirect_to questions_path, notice: 'Your question successfully deleted.'
    else
      redirect_to questions_path, notice: 'Only author can delete question.'
    end
  end

  def purge_file
    file = @question.files.find(params[:file_id])
  rescue ActiveRecord::RecordNotFound
    redirect_to @question, { alert: 'Файл не найден' }
  else
    file.purge
    render :edit
  end

  private

  def respond_question_json
    { id: @question.id.to_s,
      title: @question.title,
      body: @question.body,
      author_id: @question.author_id,
      votes_value: @question.votes_value }
  end

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions',
      respond_question_json
    )

  end

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :file_id, files: [],
                                     links_attributes: %i[name url id _destroy], reward_attributes: %i[name image])
  end
end
