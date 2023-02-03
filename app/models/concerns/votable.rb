# frozen_string_literal: true

module Votable
  extend ActiveSupport::Concern
  included do
    has_many :votes, dependent: :destroy, as: :votable
  end

  def votes_value
    votes.sum('val')
  end

  def have_vote?(user)
    !votes.where(author: user).empty?
  end

  def set_vote(user, val)
    author_vote = votes.where(author: user)
    if author_vote.empty? && author != user
      votes.new(author: user, val: val).save
    else
      author_vote.delete_all
    end
  end
end
