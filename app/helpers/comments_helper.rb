# frozen_string_literal: true

module CommentsHelper
  def element_id(commentable)
    "#{commentable.class.to_s.downcase}-#{commentable.id}"
  end

  def data_commentable_id(commentable)
    { "data-commentable-id": "#{commentable.id}",
      "data-commentable": "#{commentable_to_s(commentable)}" }
  end

  def new_comment(resource)
    new_comment_path(resource)
  end

  def commentable_to_s(commentable)
    commentable.class.to_s.downcase
  end

  private

  def new_comment_path(commentable)
    send("create_comment_#{commentable_to_s(commentable)}_url".to_sym, commentable)
  end

  def index_path(commentable)
    send("comments_#{commentable_to_s(commentable)}_path".to_sym, commentable)
  end
end
