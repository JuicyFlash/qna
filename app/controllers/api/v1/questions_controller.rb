class Api::V1::QuestionsController < Api::V1::BaseController

  before_action :find_user, only: %i[create update destroy]
  before_action :find_question, only: %i[update destroy]

  def index
    @questions ||= Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    @question = Question.with_attached_files.find(params[:id])
    render json: @question
  end

  def create
    @question = @user.questions.new(question_params)
    authorize @question
    head :ok  if @question.save!
  end

  def update
    authorize @question
    head :ok if @question.update!(question_params)
  end

  def destroy
    authorize @question
    head :ok if @question.destroy!
  end

  private

  def find_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: %i[name url id _destroy])
  end

  def find_user
    @user = User.find(params[:user_id])
  end

  def pundit_user
    @user
  end
end
