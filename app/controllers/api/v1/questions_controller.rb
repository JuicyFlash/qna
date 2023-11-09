class Api::V1::QuestionsController < Api::V1::BaseController

  def index
    @questions ||= Question.all
    render json: @questions, each_serializer: QuestionsSerializer
  end

  def show
    @question = Question.with_attached_files.find(params[:id])
    render json: @question
    #render json: url_for(@question.files.first)
  end
end