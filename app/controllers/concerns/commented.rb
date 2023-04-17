# frozen_string_literal: true

module Commented
  extend ActiveSupport::Concern
  included do
    before_action :set_commentable, only: %i[comments create_comment]
    after_action :publish_comment, only: %i[create_comment]
  end

  def comments
    @comments = @commentable.comments
    @comment = @commentable.comments.new
  end

  def create_comment
    @comment = @commentable.comments.new(comment_params)
    @comment.user_id = current_user.id
    @comment.save
    respond_to do |format|
      format.json { render json: respond_comment_json }
    end
  end

  private

  def publish_comment
    return if @comment.errors.any?

    CommentsChannel.broadcast_to(
      "#{@commentable.class.to_s}-#{@commentable.id}-comments",
      respond_comment_json
    )
  end

  def comment_params
    params.permit(:body)
  end

  def respond_comment_json
    { user_id: current_user.id,
      commentable: model_klass.to_s.downcase.to_s,
      commentable_id: @commentable.id.to_s,
      comment_id: @comment.id.to_s,
      author_id: @comment.author.id,
      body: @comment.body }
  end

  def model_klass
    controller_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params[:id])
  end
end
