class CommentsChannel < ApplicationCable::Channel

  def follow
    stream_for commentable
  end

  def unfollow
    stop_stream_for commentable
  end

  private

  def commentable
    "#{params[:commentable].capitalize}-#{params[:room_id]}-comments"
  end
end
