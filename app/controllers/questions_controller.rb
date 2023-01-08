class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :load_question, only: %i[show edit update destroy answer purge_file]

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @best_answer = @question.best_answer
    @other_answers = @question.answers.where.not(id: @question.best_answer_id)
  end

  def new
    @question = Question.new
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created'
    else
      render :new
    end
  end

  def update
    @question.files.attach(question_params[:files]) unless question_params[:files].nil?
    if @question.update(title: question_params[:title], body: question_params[:body])
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
    file.purge unless file.nil?
    render :edit
  end

  private

  def load_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, :file_id, files: [])
  end
end
