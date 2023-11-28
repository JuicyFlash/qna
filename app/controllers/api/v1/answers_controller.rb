class Api::V1::AnswersController < Api::V1::BaseController

  before_action :find_user, only: %i[create update destroy]
  before_action :find_question, only: %i[create]
  before_action :find_answer, only: %i[update destroy]

  def index
    @answers ||= Answer.all
    render json: @answers, each_serializer: AnswersSerializer
  end

  def show
    @answer = Answer.find(params[:id])
    render json: @answer
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.author_id = @user.id
    authorize @answer
    head :ok  if @answer.save!
  end

  def update
    authorize @answer
    head :ok  if @answer.update!(answer_params)
  end

  def destroy
    authorize @answer
    head :ok if @answer.destroy!
  end

  private

  def answer_params
    params.require(:answer).permit(:body, links_attributes: %i[name url id _destroy])
  end

  def find_user
    @user = User.find(params[:user_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def pundit_user
    @user
  end
end
